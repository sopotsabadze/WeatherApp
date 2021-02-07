//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Sopo on 1/15/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet var cloudiness: UILabel!
    @IBOutlet var humidity: UILabel!
    @IBOutlet var windSpeed: UILabel!
    @IBOutlet var windDirection: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setCloudiness(number: Float) {
        cloudiness.text = String(format:"%.0f", number) + " %"
    }
    
    func setHumidity(number: Float) {
        humidity.text = String(format:"%.0f", number) + " mm"
    }
    
    func setWindSpeed(number: Float) {
        windSpeed.text = String(format:"%.2f", number) + " km/h"
    }
    
    func setWindDirection(number: Float) {
        var direction: String = "N"
//        if 45 < Int(number) <= 135 {
//            direction = "E"
//        } else if 135 < Int(number) <= 225 {
//            direction = "S"
//        } else if 225 < Int(number) <= 315 {
//            direction = "W"
//        }
        windDirection.text = direction
    }

}
