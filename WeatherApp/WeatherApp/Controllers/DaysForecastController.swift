//
//  DaysForecastController.swift
//  WeatherApp
//
//  Created by Sopo on 1/12/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class DaysForecastController: UIViewController {
    
    @IBOutlet var forecastTable: UITableView!
    @IBOutlet var loader: UIActivityIndicatorView!
    @IBOutlet var refreshButton: UIBarButtonItem!
    
    private var service = Service()
    private var daysForecast = [DaysForecast]()
    private var dataLoaded = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupForecastTable()
        setupGradients(view: self.view, color1: Color.blue3, color2: Color.blue4)
        loadForecastData()
    }
    
    private func setupForecastTable() {
        forecastTable.delegate = self
        forecastTable.dataSource = self

        forecastTable.register(UINib(nibName: "DayCell", bundle: nil), forCellReuseIdentifier: "DayCell")
        forecastTable.register(UINib(nibName: "ForecastCell", bundle: nil), forCellReuseIdentifier: "ForecastCell")
    }
    
    
    private func setupGradients(view: UIView, color1: String, color2: String) {
        let startColor = UIColor(named: color1)
        let endColor = UIColor(named: color2)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [startColor?.cgColor, endColor?.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    @IBAction func refreshButtonDidTap () {
        loadForecastData()
    }
    
    private func loadForecastData() {
        forecastTable.isHidden = true
        loader.startAnimating()
        service.loadDaysForecast(city: "London", country: "uk") { [weak self] result in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loader.stopAnimating()
                switch result {
                    
                case .success(let forecast):
                    self.successAction(daysForecast: forecast)
                    
                case .failure(let error):
                    self.failureAction(error: error)
                }
            }
        }
    }
    
    private func successAction(daysForecast: [DaysForecast]) {
        dataLoaded = true
        forecastTable.isHidden = false
        self.daysForecast = daysForecast
        self.forecastTable.reloadData()
        print("-------------------")
        print(self.daysForecast)
    }
    
    private func failureAction(error: Error) {
        dataLoaded = false
        let alert = UIAlertController(
            title: "Error!",
            message: error.localizedDescription,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(
            title: "OK",
            style: .default,
            handler: nil
        ))
        self.present(alert, animated: true, completion: nil)
    }
    
    func updateDayCell(dayCell: DayCell, index: Int) {
        if dataLoaded == true {
            let dayForecast = daysForecast[index]
            dayCell.setDay(text: getForecastDay(date: dayForecast.dt_txt))
            dayCell.layoutMargins = UIEdgeInsets.zero
            dayCell.preservesSuperviewLayoutMargins = false
        }
    }
    
    private func getForecastDay(date: String) -> String {
        let dateText = date.prefix(10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: String(dateText)) else { return "ERROR" }
        let calendar = Calendar(identifier: .gregorian)
        let dayIndex = calendar.component(.weekday, from: date)
        let weekDay = dateFormatter.weekdaySymbols[dayIndex - 1]
        return weekDay.uppercased()
    }

    func updateForecastCell(forecastCell: ForecastCell, section: Int, row: Int) {
        if dataLoaded == true {
            let dayForecast = daysForecast[section]
            let dayWeathers = dayForecast.weather
            for dayWeather in dayWeathers {
                forecastCell.setIcon(text: dayWeather.icon)
                forecastCell.setTime(text: getForecastTime(date: dayForecast.dt_txt))
                forecastCell.setMessage(text: dayWeather.description)
                forecastCell.setTemperature(number: dayForecast.main.temp)
            }
        }
    }
    
    private func getForecastTime(date: String) -> String {
        var time = date.suffix(8)
        time = time.prefix(5)
        return String(time)
    }
}


extension DaysForecastController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.sectionsNum
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Constants.numInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell = forecastTable.dequeueReusableCell(withIdentifier: "DayCell", for: indexPath)
            if let dayCell = cell as? DayCell {
                self.updateDayCell(dayCell: dayCell, index: indexPath.row)
            }
            return cell
        }

        let cell = forecastTable.dequeueReusableCell(withIdentifier: "ForecastCell", for: indexPath)

        if let forecastCell = cell as? ForecastCell {
            self.updateForecastCell(forecastCell: forecastCell, section: indexPath.section, row: indexPath.row)
        }
        return cell
    }
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 { return 40 }
        return 65
    }
}


extension DaysForecastController {
    struct Constants {
        static let sectionsNum: Int = 5
        static let numInSection: Int = 5
        static let edge: CGFloat = 15
        static let cellHeight: CGFloat = 160
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


