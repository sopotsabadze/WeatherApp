//
//  UIViewExtension.swift
//  WeatherApp
//
//  Created by Sopo on 1/14/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

extension UIView {
    
    @IBInspectable var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set { layer.cornerRadius = newValue }
    }
    
    @IBInspectable var borderColor: UIColor? {
        get { return UIColor(cgColor: layer.borderColor!) }
        set { layer.borderColor = newValue?.cgColor }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

}
