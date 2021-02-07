//
//  HeadlineCell.swift
//  WeatherApp
//
//  Created by Sopo on 1/15/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class HeadlineCell: UICollectionViewCell {

    @IBOutlet var icon: UIImageView!
    @IBOutlet var location: UILabel!
    @IBOutlet var temperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setIcon(text: String) {
        let iconUrl = URL(string: "http://api.openweathermap.org/img/w/" + text + ".png")
        self.icon.sd_setImage(with: iconUrl, placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    func setLocation(city: String, country: String) {
        location.text = city + ", " + country
    }
    
    func setTemperature(temperature: Float, message: String) {
        self.temperature.text = String(format:"%.0f", temperature) + "°C | " + message
    }

}
