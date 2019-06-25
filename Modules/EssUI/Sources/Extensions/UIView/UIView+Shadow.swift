//
//  UIView+Shadow.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssResources
import EssDI

fileprivate struct Constants {
    static var shadowWidth: CGFloat = 8.0
    static var shadowOpacity: Float = 0.6
}

public extension UIView {
    func drawShadow(width: CGFloat, color: UIColor? = nil) {
        layer.shadowColor = color?.cgColor ?? (backgroundColor?.cgColor ?? (inject() as AppColorInterface).appTitleColor.cgColor)
        layer.shadowOpacity = Constants.shadowOpacity
        layer.shadowRadius = Constants.shadowWidth
        layer.masksToBounds =  false
    }
}
