//
//  DayCell.swift
//  WeatherApp
//
//  Created by Sopo on 1/12/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class DayCell: UITableViewCell {
    
    @IBOutlet var day: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.layer.backgroundColor = UIColor.clear.cgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func setDay(text: String) {
        day.text = text
    }
    
}
