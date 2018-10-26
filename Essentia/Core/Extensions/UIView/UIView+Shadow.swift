//
//  UIView+Shadow.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var shadowWidth: CGFloat = 8.0
    static var shadowOpacity: Float = 0.35
}

extension UIView {
    func drawShadow(width: CGFloat) {
        layer.shadowColor = backgroundColor?.cgColor ?? UIColor.black.cgColor
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowWidth
        layer.masksToBounds =  false
    }
}