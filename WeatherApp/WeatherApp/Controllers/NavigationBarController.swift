//
//  NavigationBarController.swift
//  WeatherApp
//
//  Created by Sopo on 1/12/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class NavigationBarController: UINavigationController {
    
//    static func setTransparentTabBar() {
//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().clipsToBounds = true
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let barAppearence = UINavigationBarAppearance()
        barAppearence.configureWithTransparentBackground()
        barAppearence.backgroundImage = UIImage()
        barAppearence.shadowImage = UIImage()
//        barAppearence.backgroundColor = .clear
        
        navigationBar.compactAppearance = barAppearence
        navigationBar.standardAppearance = barAppearence
//        navigationBar.scrollEdgesAppearance = barAppearence
    }
}
