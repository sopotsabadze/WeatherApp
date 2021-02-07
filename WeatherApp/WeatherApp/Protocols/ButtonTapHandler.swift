//
//  ButtonTapHandler.swift
//  WeatherApp
//
//  Created by Sopo on 2/3/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

protocol ButtonTapHandler {
    func loadCityData(city: String)
    func reloadPageData(error: String)
}
