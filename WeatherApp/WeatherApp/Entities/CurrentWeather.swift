//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Sopo on 1/20/21.
//  Copyright © 2021 iOS. All rights reserved.

import Foundation


struct CurrentWeather: Codable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let clouds: Clouds
    let sys: System
    let name: String
    
//    init (weather: [Weather], main: Main, wind: Wind, clouds: Clouds, sys: System, name: String) {
//        self.weather = weather
//        self.main = main
//        self.wind = wind
//        self.clouds = clouds
//        self.sys = sys
//        self.name = name
//    }
}

struct Weather: Codable {
    let main: String
    let icon: String
}

struct Main: Codable {
    let temp: Float
    let humidity: Float
}

struct Wind: Codable {
    let speed: Float
    let deg: Float
}

struct Clouds: Codable {
    let all: Float
}

struct System: Codable {
    let country: String
}






//        let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=fe625b36eab3c5a4784ca4e4a2e75bc3")
//        let request = URLRequest(url: url!)
//
//        let task = URLSession.shared.dataTask(
//            with: request,
//            completionHandler: {
//                data, response, error in
//                print(data, response, error)
//            }
//        )
//        task.resume()


