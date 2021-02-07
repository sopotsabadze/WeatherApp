//
//  CarouselCell.swift
//  WeatherApp
//
//  Created by Sopo on 2/4/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class CarouselCell: UICollectionViewCell {

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var view: UIView!
    private lazy var cities = [CityWeather]()
    private var currentWeather: CurrentWeather? = nil
    private var currentSection = -1
    private var firstRunning: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.register(
                UINib(nibName: "HeadlineCell", bundle: nil),
                forCellWithReuseIdentifier: "HeadlineCell"
        )
        
        collectionView.register(
            UINib(nibName: "WeatherCell", bundle: nil),
            forCellWithReuseIdentifier: "WeatherCell"
        )
        
        setupGradients(view: self.contentView, color1: Color.blue1, color2: Color.blue2)
        setupShadows(view: self.contentView, color: Color.blue1)
    }
    
    func setupGradients(view: UIView, color1: String, color2: String) {
        let startColor = UIColor(named: color1)
        let endColor = UIColor(named: color2)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [startColor?.cgColor, endColor?.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupShadows(view: UIView, color: String) {
        let uicolor = UIColor(named: color)
        view.layer.shadowColor = uicolor?.cgColor
        view.layer.shadowOpacity = 0.7
        view.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        view.layer.shadowRadius = 10.0
        
    }

    
    func updateCarouselCell(section: Int, cities: [CityWeather], weatherData: CurrentWeather, firstRunning: Bool) {
        self.currentSection = section
        self.cities = cities
        self.currentWeather = weatherData
        self.firstRunning = firstRunning
        collectionView.reloadData()
    }
    
    
    func updateHeadlineCell(headlineCell: HeadlineCell, section: Int) {
        if currentWeather != nil {
            let icon: String = currentWeather!.weather[0].icon
            headlineCell.setIcon(text: icon)
            cities[section].icon = icon
            let city: String = cities[section].city!
            let country: String = cities[section].country ?? "Unknown country"
            headlineCell.setLocation(city: city, country: country)
            let temperature: Float = currentWeather!.main.temp
            let message: String = currentWeather!.weather[0].main
            headlineCell.setTemperature(temperature: temperature, message: message)
            cities[section].temperature = temperature
            cities[section].message = message
        }
    }
    
    
    func updateWeatherCell(weatherCell: WeatherCell, section: Int) {
        let cloudiness: Float = currentWeather!.clouds.all
        weatherCell.setCloudiness(number: cloudiness)
        cities[section].cloudiness = cloudiness
        let humidity: Float = currentWeather!.main.humidity
        weatherCell.setHumidity(number: humidity)
        cities[section].humidity = humidity
        let windSpeed: Float = currentWeather!.wind.speed
        weatherCell.setWindSpeed(number: windSpeed)
        cities[section].windSpeed = windSpeed
        let windDirection: Float = currentWeather!.wind.deg
        weatherCell.setWindDirection(number: windDirection)
        cities[section].windDirection = windDirection
    }
}



extension CarouselCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeadlineCell", for: indexPath)
            if let headlineCell = cell as? HeadlineCell {
                self.updateHeadlineCell(headlineCell: headlineCell, section: currentSection)
            }
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath)
        if let weatherCell = cell as? WeatherCell {
            self.updateWeatherCell(weatherCell: weatherCell, section: currentSection)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = collectionView.frame.width
        let cellHeight: CGFloat = collectionView.frame.height / 2
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


extension CarouselCell {
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
