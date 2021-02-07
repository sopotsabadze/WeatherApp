//
//  ErrorPopup.swift
//  WeatherApp
//
//  Created by Sopo on 2/3/21.
//  Copyright © 2021 iOS. All rights reserved.
//

import UIKit

class ErrorPopup: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet var errorMessage: UILabel!
    var tapHandler: ButtonTapHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder){
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit() {
        let bundle = Bundle(for: Popup.self)
        bundle.loadNibNamed("ErrorPopup", owner: self, options: nil)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(contentView)
    }
    
    func setErrorMessage(error: String) {
        errorMessage.text = error
    }
}
