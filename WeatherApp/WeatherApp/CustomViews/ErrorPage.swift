//
//  ErrorPage.swift
//  WeatherApp
//
//  Created by Sopo on 2/3/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class ErrorPage: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var errorMessage: UILabel!
    var tapHandler: ButtonTapHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupGradients(view: contentView, color1: Color.blue3, color2: Color.blue4)
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        commonInit()
        setupGradients(view: contentView, color1: Color.blue3, color2: Color.blue4)
    }
    
    func commonInit() {
        let bundle = Bundle(for: Popup.self)
        bundle.loadNibNamed("ErrorPage", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    private func setupGradients(view: UIView, color1: String, color2: String) {
        let startColor = UIColor(named: color1)
        let endColor = UIColor(named: color2)
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [startColor?.cgColor, endColor?.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setErrorMessage(error: String) {
        errorMessage.text = error
    }
    
    @IBAction func reloadButtonDidTap() {
        tapHandler?.reloadPageData(error: "")
    }
}


extension ErrorPage {
    struct Color {
        static let blue3: String = "bg-gradient-start"
        static let blue4: String = "bg-gradient-end"
    }
}
