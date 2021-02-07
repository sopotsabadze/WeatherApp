//
//  TodayForecastController.swift
//  WeatherApp
//
//  Created by Sopo on 1/12/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit
import CoreData
import CoreLocation
import UPCarouselFlowLayout
import SDWebImage

class CurrentWeatherController: UIViewController, ButtonTapHandler {
    @IBOutlet var weatherCollection: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var popup: Popup!
    @IBOutlet var errorPopup: ErrorPopup!
    @IBOutlet var errorPage: ErrorPage!
    @IBOutlet var blurEffect: UIVisualEffectView!
    
    var dbContext = DBManager.shared.persistentContainer.viewContext
    private lazy var cities = [CityWeather]()
    private var service = Service()
    private var currentWeathers: [String: CurrentWeather] = [:]

    let locationManager = CLLocationManager()
    private var currentLocation: String? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        deleteAllData()
//
//        var city = CityWeather(context: self.dbContext)
//        city.city = "Tbilisi"
//        city.country = "Georgia"
//        do {
//            try self.dbContext.save()
//        } catch {}
//
//
//        city = CityWeather(context: self.dbContext)
//        city.city = "London"
//        city.country = "Great Britain"
//        do {
//            try self.dbContext.save()
//        } catch {}
//
//
//        city = CityWeather(context: self.dbContext)
//        city.city = "Moscow"
//        city.country = "Russia"
//        do {
//            try self.dbContext.save()
//        } catch {}
        
        checkLocationServices()
        setupCarouselView()
        fetchCitiesWeathers()
        updateCurrentWeathers()
        setupOtherParameters()
        setupGradients(view: self.view, color1: Color.blue3, color2: Color.blue4)
        
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addButton.cornerRadius = addButton.frame.width/2
        popup.cornerRadius = 32
        errorPopup.cornerRadius = 24
    }
    
    
    func deleteAllData() {
        let request = CityWeather.fetchRequest() as NSFetchRequest<CityWeather>
        request.returnsObjectsAsFaults = false
        do {
            let result = try dbContext.fetch(request)
            for city in result {
                let cityData = city as NSManagedObject
                dbContext.delete(cityData)
            }
        } catch {}
    }

    
    private func setupCarouselView() {
        weatherCollection.delegate = self
        weatherCollection.dataSource = self
        
        let layout = UPCarouselFlowLayout()
        layout.spacingMode = UPCarouselFlowLayoutSpacingMode.overlap(visibleOffset: 10)
        layout.scrollDirection = .horizontal
        layout.sideItemAlpha = 1
        layout.sideItemScale = 0.8
        weatherCollection.collectionViewLayout = layout
        
        weatherCollection.layer.backgroundColor = UIColor.clear.cgColor
        
         weatherCollection.register(
            UINib(nibName: "CarouselCell", bundle: nil),
            forCellWithReuseIdentifier: "CarouselCell"
        )
    }
    
    
    private func fetchCitiesWeathers() {
        let request = CityWeather.fetchRequest() as NSFetchRequest<CityWeather>
        request.returnsObjectsAsFaults = false
        do {
            cities = try dbContext.fetch(request)
            print(cities)
        } catch {
            // error alarm
        }
    }
    
    
    private func updateCurrentWeathers() {
        for i in 0...cities.count - 1 {
            let cityData: CityWeather = cities[i]
            // weather
            let message: String = cityData.message ?? "No detail"
            let icon: String = cityData.icon ?? "No icon"
            let weather = Weather(main: message, icon: icon)
            
            // main
            let temperature: Float = cityData.temperature
            let humidity: Float = cityData.humidity
            let main = Main(temp: temperature, humidity: humidity)
            
            // wind
            let windSpeed: Float = cityData.windSpeed
            let windDirection: Float = cityData.windDirection
            let wind = Wind(speed: windSpeed, deg: windDirection)

            // cloud
            let cloudiness: Float = cityData.cloudiness
            let clouds = Clouds(all: cloudiness)
            
            // sys
            let country: String = cityData.country!
            let sys = System(country: country)
            
            let name: String = cityData.city!
            
            let currentWeather = CurrentWeather(weather: [weather], main: main, wind: wind, clouds: clouds, sys: sys, name: name)
        
            currentWeathers[name] = currentWeather
        }
        weatherCollection.reloadData()

    }
    
    
    private func setupOtherParameters() {
        weatherCollection.addGestureRecognizer(
            UILongPressGestureRecognizer(
                target: self,
                action: #selector(handleLongPress(gesture:))
            )
        )

        errorPage.tapHandler = self
        popup.tapHandler = self

        errorPage.isHidden = true
        errorPopup.isHidden = true
        popup.isHidden = true
        blurEffect.isHidden = true
    }
    
    
    private func setupGradients(view: UIView, color1: String, color2: String) {
        let startColor = UIColor(named: color1)
        let endColor = UIColor(named: color2)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [startColor?.cgColor, endColor?.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func loadWeatherDataFromApi() {
        weatherCollection.isHidden = true
        addButton.isHidden = true
        loader.startAnimating()
        var loadedNum: Int = 0
        var failed: Bool = false
        let semaphore = DispatchSemaphore(value: 1)
        
        for i in 0...cities.count - 1 {
            let city: String = cities[i].city!
            service.loadCurrentWeather(city: city) { [weak self] result in
                guard let self = self else { return }
                
                semaphore.wait()
                if failed == false {
                
                    if case .failure(let error) = result {
                        failed = true
                        DispatchQueue.main.async {
                            self.loader.stopAnimating()
                            self.failureAction(errorMessage: error.localizedDescription)
                        }
                        semaphore.signal()
                    }
                    else {
                        if case .success(let weatherData) = result {
                            let city: String = weatherData.name
                            self.currentWeathers[city] = weatherData
                            
                            if loadedNum == self.cities.count - 1 {
                                DispatchQueue.main.async {
                                    self.loader.stopAnimating()
                                    self.successAction()
                                }
                                self.updateCities()
                            } else { loadedNum += 1 }
                            semaphore.signal()
                        }
                    }
                }
                semaphore.signal()
            }
        }
    }
    
    
    private func successAction() {
        weatherCollection.isHidden = false
        addButton.isHidden = false
        
        let sections = IndexSet(0...cities.count-1)
        self.weatherCollection.reloadSections(sections)
    }


    private func failureAction(errorMessage: String) {
        errorPage.setErrorMessage(error: errorMessage)
        showErrorPage()
        
//        let alert = UIAlertController(
//            title: "Error!",
//            message: error.localizedDescription,
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(
//            title: "OK",
//            style: .default,
//            handler: nil
//        ))
//        self.present(alert, animated: true, completion: nil)
    }
    
    
    private func updateCities() {
        for i in 0...cities.count - 1 {
            let city: String = cities[i].city!
            cities[i].city = city
            let currentWeather: CurrentWeather = currentWeathers[city]!
            let country: String = cities[i].country ?? "Unknown country"
            cities[i].country = country
            let icon: String = currentWeather.weather[0].icon
            cities[i].icon = icon
            let temperature: Float = currentWeather.main.temp
            cities[i].temperature = temperature
            let message: String = currentWeather.weather[0].main
            cities[i].message = message
            let cloudiness: Float = currentWeather.clouds.all
            cities[i].cloudiness = cloudiness
            let humidity: Float = currentWeather.main.humidity
            cities[i].humidity = humidity
            let windSpeed: Float = currentWeather.wind.speed
            cities[i].windSpeed = windSpeed
            let windDirection: Float = currentWeather.wind.deg
            cities[i].windDirection = windDirection
        }
        do  {
            try self.dbContext.save()
        } catch {}
    }
    
    
    @IBAction func refreshButtonDidTap () {
        loadWeatherDataFromApi()
    }
    
    
    func reloadPageData(error: String) {
        hideErrorPage()
        self.weatherCollection.reloadData()
    }
    
    private func showErrorPage() {
        errorPage.isHidden = false
        view.bringSubviewToFront(self.errorPage)
    }
    
    private func hideErrorPage() {
        errorPage.isHidden = true
        view.sendSubviewToBack(self.errorPage)
    }
    
    @IBAction func addCityButtonDidTap() {
        blurEffect.isHidden = false
        self.view.bringSubviewToFront(blurEffect)
        popup.isHidden = false
        self.view.bringSubviewToFront(popup)
    }
        
        
    func loadCityData(city: String) {
        popup.addLabel.isHidden = true
        popup.loader.startAnimating()
        self.hideErrorPopup()
    
        service.loadCurrentWeather(city: city) { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.popup.loader.stopAnimating()
                switch result {
                case .success(let weather):
                    self.currentWeathers[city] = weather
                    let countryCode: String = weather.sys.country
                    let country: String  = self.getCountryName(from: countryCode)
                    self.addNewCityToCarousel(city: city, country: country, cityData: weather)
                    self.popup.addLabel.isHidden = false

                case .failure(let error):
                    self.showErrorPopup()
                    self.popup.addLabel.isHidden = false
                }
            }
        }
    }

        
    private func getCountryName(from countryCode: String) -> String {
        if let country = (Locale.current as NSLocale).displayName(forKey: .countryCode, value: countryCode) {
            return country
        }
        return countryCode
    }

        
    private func showErrorPopup() {
        errorPopup.isHidden = false
        self.view.bringSubviewToFront(errorPopup)
    }
    
    
    private func hideErrorPopup() {
        errorPopup.isHidden = true
        self.view.sendSubviewToBack(errorPopup)
    }
    
    
    func addNewCityToCarousel(city: String, country: String, cityData: CurrentWeather) {
        print("Adding new city...")
        self.saveCityInDatabase(city: city, country: country, weather: cityData)

        blurEffect.isHidden = true
        self.view.sendSubviewToBack(blurEffect)
        popup.isHidden = true
        self.view.sendSubviewToBack(popup)

        self.weatherCollection.reloadData()
    }
    
    
    private func saveCityInDatabase(city: String, country: String, weather: CurrentWeather) {
        let cityData = CityWeather(context: self.dbContext)
        cityData.city = city
        cityData.country = country
        cityData.icon = weather.weather[0].icon
        cityData.temperature = weather.main.temp
        cityData.message = weather.weather[0].main
        cityData.cloudiness = weather.clouds.all
        cityData.humidity = weather.main.humidity
        cityData.windSpeed = weather.wind.speed
        cityData.windDirection = weather.wind.deg

        do  {
            try self.dbContext.save()
            self.fetchCitiesWeathers()
        } catch {}
    }
    
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer!) {
        let location = gesture.location(in: weatherCollection)
        if let indexPath = weatherCollection.indexPathForItem(at: location) {
            let city: String = cities[indexPath.section].city!
            
            let alert = UIAlertController(title: "Delete " + city + "?", message: "City's weather data will be deleted", preferredStyle: .alert)
            
            alert.addAction(
                UIAlertAction(
                    title: "Delete",
                    style: .destructive,
                    handler: { [unowned self] _ in
                        self.deleteCityFromDatabase(index: indexPath.section)
                        self.updateCurrentWeathers()
                        self.blurEffect.isHidden = true
                        self.view.sendSubviewToBack(self.blurEffect)
                    }
                )
            )
            
            alert.addAction(
                UIAlertAction(
                    title: "Cancel",
                    style: .cancel,
                    handler: { [unowned self] _ in
                        self.blurEffect.isHidden = true
                        self.view.sendSubviewToBack(self.blurEffect)
                    }
                )
            )
            
            blurEffect.isHidden = false
            self.view.bringSubviewToFront(blurEffect)
            present(alert, animated: true, completion: nil)
        }
    }
    
    
    private func deleteCityFromDatabase(index: Int) {
        let cityData = self.cities[index]
        self.dbContext.delete(cityData)
        
        do {
            try self.dbContext.save()
            // muki poni
            self.fetchCitiesWeathers()
        } catch {
            // can't delete city
        }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let location = firstTouch.location(in: self.view)
            let frame = self.view.convert(popup.frame, from: self.view)
            let originX = frame.minX
            let originY = frame.minY
            let width = frame.width
            let height = frame.height
            
            if location.x < originX || location.x > originX + width || location.y < originY || location.y > originY + height {
                popup.isHidden = true
                self.view.sendSubviewToBack(popup)
                blurEffect.isHidden = true
                self.view.sendSubviewToBack(blurEffect)
                hideErrorPopup()
            }
        } else { return }
    }
    

    
    
    private func setupPageControl() {
        pageControl.numberOfPages = cities.count
    }
    
    func checkLocationServices() {
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
            checkLocationAuthorization()
        } else {
    
        }
    }
    
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    
    func checkLocationAuthorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            locationManager.startUpdatingLocation()
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            // show alert
            break
        case .restricted:
            // show alert
            break
        case .authorizedAlways: break
        }
    }

    
}



extension CurrentWeatherController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        self.setupPageControl()
        return cities.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Constants.itemsInSection
    }
    

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print(indexPath.section)
        let cell = weatherCollection.dequeueReusableCell(withReuseIdentifier: "CarouselCell", for: indexPath)
        if let carouselCell = cell as? CarouselCell {
            let section = indexPath.section
            let city: String = cities[section].city!
            let weatherData = currentWeathers[city]!
            carouselCell.updateCarouselCell(section: section, cities: cities, weatherData: weatherData, firstRunning: false)
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = weatherCollection.frame.width - 2 * Constants.edgePadding
        let cellHeight: CGFloat = weatherCollection.frame.height / CGFloat(Constants.itemsInSection)
        return CGSize(width: cellWidth, height: cellHeight)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0 {
            return UIEdgeInsets(top: 0, left: Constants.edgePadding, bottom: 0, right: 0)
        }
        if section == cities.count - 1 {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: Constants.edgePadding)
        }
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    
}


extension CurrentWeatherController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        self.checkLocationAuthorization()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let currLongitude = location.coordinate.longitude
        let currLatitude = location.coordinate.latitude
        print(currLongitude)
        print(currLatitude)
    }
}


extension CurrentWeatherController  {
    struct Constants {
        static let itemsInSection: Int = 1
        static let edgePadding: CGFloat = 48
    }
    
    struct Color {
        static let blue1: String = "blue-gradient-start"
        static let blue2: String = "blue-gradient-end"
        static let blue3: String = "bg-gradient-start"
        static let blue4: String = "bg-gradient-end"
        static let green1: String = "green-gradient-start"
        static let green2: String = "green-gradient-end"
        static let pink1: String = "ochre-gradient-start"
        static let pink2: String = "ochre-gradient-end"
    }
}
