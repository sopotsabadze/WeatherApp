//
//  Popup.swift
//  WeatherApp
//
//  Created by Sopo on 1/19/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class Popup: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var textField: UITextField!
    @IBOutlet var addLabel: UILabel!
    @IBOutlet var loader: UIActivityIndicatorView!
    
    var tapHandler: ButtonTapHandler?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        contentView.cornerRadius = 32
        setupGradients(view: contentView, color1: Color.green1, color2: Color.green2)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        commonInit()
        contentView.cornerRadius = 32
        setupGradients(view: contentView, color1: Color.green1, color2: Color.green2)
    }
    
    func commonInit() {
        let bundle = Bundle(for: Popup.self)
        bundle.loadNibNamed("Popup", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    func setupGradients(view: UIView, color1: String, color2: String) {
        let startColor = UIColor(named: color1)
        let endColor = UIColor(named: color2)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = contentView.bounds
        gradient.colors = [startColor?.cgColor, endColor?.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    
    private func getCityName() -> String {
        var input = textField.text
        if input != "" {
            input = input!.prefix(1).uppercased() + input!.suffix(input!.count - 1).lowercased()
        }
        return input ?? ""
    }
    
    
    @IBAction func addButtonDidTap() {
        let city = getCityName()
        tapHandler?.loadCityData(city: city)
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        scrollView.setContentOffset(CGPoint(x: 0, y: 200), animated: true)
//    }
//
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        if textField == emailField {
//            passwordField.becomeFirstResponder()
//            return false
//        }
//        loginDialPad()
//        textField.resignFirstResponder()
//        return true
//    }
//
//
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        UIView.animate(
//            withDuration: 0.5,
//            animations: {
//                self.scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
//            }
//        )
//    }
    
}


extension Popup  {
    struct Color {
        static let green1: String = "green-gradient-start"
        static let green2: String = "green-gradient-end"
    }
}
