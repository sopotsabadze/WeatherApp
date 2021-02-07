//
//  DaysWeather.swift
//  WeatherApp
//
//  Created by Sopo on 1/21/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation

struct ForecastList: Codable {
    let list: [DaysForecast]
}

struct DaysForecast: Codable {
    let main: MainWeather
    let weather: [DayWeather]
    let dt_txt: String
}

struct MainWeather: Codable {
    let temp: Float
}

struct DayWeather: Codable {
    let description: String
    let icon: String
}




//func checkLocationServices() {
//    if CLLocationManager.locationServicesEnabled() {
//        setupLocationManager()
//        checkLocationAuthorization()
//    } else {
//        
//    }
//}
//
//
//func setupLocationManager() {
//    locationManager.delegate = self
//    locationManager.desiredAccuracy = kCLLocationAccuracyBest
//    locationManager.requestWhenInUseAuthorization()
//    locationManager.startUpdatingLocation()
//}
//
//
//func checkLocationAuthorization() {
//    switch CLLocationManager.authorizationStatus() {
//    case .authorizedWhenInUse:
//        locationManager.startUpdatingLocation()
//        break
//    case .notDetermined:
//        locationManager.requestWhenInUseAuthorization()
//        break
//    case .denied:
//        // show alert
//        break
//    case .restricted:
//        // show alert
//        break
//    case .authorizedAlways: break
//    }
//}
