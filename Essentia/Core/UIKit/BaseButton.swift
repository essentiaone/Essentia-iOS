//
//  BaseButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseButton: UIButton {
    func drawCornerRadius() {
        layer.cornerRadius = 5.0
    }
    
    func setFont() {
        titleLabel?.font = AppFont.regular.withSize(15.0)
    }
}
