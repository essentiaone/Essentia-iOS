//
//  BaseButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssResources

fileprivate struct Constants {
    static var cornerRadius: CGFloat = 5.0
}

class BaseButton: UIButton {
    func drawCornerRadius() {
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func setFont() {
        titleLabel?.font = AppFont.regular.withSize(15.0)
    }
}
