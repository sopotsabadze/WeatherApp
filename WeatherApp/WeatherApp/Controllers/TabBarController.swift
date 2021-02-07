//
//  TabBarController.swift
//  WeatherApp
//
//  Created by Sopo on 1/12/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class TabBarController: UITabBar {
    
    static func setTransparentTabBar() {
        UITabBar.appearance().backgroundImage = UIImage()
        UITabBar.appearance().shadowImage = UIImage()
        UITabBar.appearance().clipsToBounds = true
    }
}
