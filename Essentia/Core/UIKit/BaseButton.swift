//
//  BaseButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var shadowWidth: CGFloat = 8.0
    static var cornerRadius: CGFloat = 5.0
    static var shadowOpacity: Float = 0.35
}

class BaseButton: UIButton {
    func drawCornerRadius() {
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func setFont() {
        titleLabel?.font = AppFont.regular.withSize(15.0)
    }
    
    func drawShadow(width: CGFloat) {
        layer.shadowColor = backgroundColor?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowWidth
        layer.masksToBounds =  false
    }
}
