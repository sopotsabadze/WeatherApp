//
//  ForecastCell.swift
//  WeatherApp
//
//  Created by Sopo on 1/12/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class ForecastCell: UITableViewCell {
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet var time: UILabel!
    @IBOutlet var message: UILabel!
    @IBOutlet var temperature: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    
    func setIcon(text: String) {
        let iconUrl = URL(string: "http://api.openweathermap.org/img/w/" + text + ".png")
        self.icon.sd_setImage(with: iconUrl, placeholderImage: UIImage(named: "placeholder.png"))
    }
    
    func setTime(text: String) {
        time.text = text
    }
    
    func setMessage(text: String) {
        message.text = text
    }
    
    func setTemperature(number: Float) {
        temperature.text = String(format:"%.0f", number) + "°C"
    }
    
}
