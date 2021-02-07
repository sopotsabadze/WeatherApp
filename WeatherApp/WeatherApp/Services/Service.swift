//
//  Service.swift
//  WeatherApp
//
//  Created by Sopo on 1/20/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import Foundation

class Service {
    
    private let apiKey = "e05685cddfa557ac56f117edd14af162"
    private var components = URLComponents()

//    "http://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=fe625b36eab3c5a4784ca4e4a2e75bc3"

    init() {
        components.scheme = "https"
        components.host = "api.openweathermap.org"
    }

    func loadCurrentWeather(city: String, completion: @escaping (Result<CurrentWeather, Error>) -> ()) {
        components.path = "/data/2.5/weather"
        
        let parameters = [
            "q": city,
            "APPID": apiKey.description,
            "units": "metric"
        ]

        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }

        if let url = components.url {
            let request = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(CurrentWeather.self, from: data)
                        completion(.success(result))
                    } catch {
                        completion(.failure(error))
                    }
                }
                else { completion(.failure(ServiceError.noData)) }
            })
            task.resume()
        }
        else {
            completion(.failure(ServiceError.invalidParameters))
        }
    }
    
    
    func loadDaysForecast(city: String, country: String, completion: @escaping (Result<[DaysForecast], Error>) -> ()) {
        components.path = "/data/2.5/forecast"

        let parameters = [
            "q": city,
            "appid": apiKey.description,
            "units": "metric"
        ]
        
        components.queryItems = parameters.map { key, value in
            return URLQueryItem(name: key, value: value)
        }
        
        if let url = components.url {
            let request = URLRequest(url: url)

            let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in

                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let result = try decoder.decode(ForecastList.self, from: data)
                        completion(.success(result.list))
                    } catch {
                        completion(.failure(error))
                    }
                }
                else { completion(.failure(ServiceError.noData)) }
            })
            task.resume()
        }
        else {
            completion(.failure(ServiceError.invalidParameters))
        }
        
    }
    
}

    
enum ServiceError: Error {
    case noData
    case invalidParameters
}
