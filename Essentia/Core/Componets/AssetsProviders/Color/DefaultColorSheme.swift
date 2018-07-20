//
//  DefaultColorSheme.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct DefaultColorSheme: AppColorInterface {
    var appBackgroundColor: UIColor = .white
    var appTitleColor: UIColor = .darkText
    var appDefaultTextColor: UIColor = RGB(98, 110, 126)
    var appLinkTextColor: UIColor = RGB(147, 164, 191)
    var centeredButtonBackgroudColor: UIColor = RGB(0, 30, 255)
    var centeredButtonTextColor: UIColor = .white
    var borderedButtonTextColor: UIColor = RGB(0, 30, 255)
    var borderedButtonBorderColor: UIColor = RGB(0, 30, 255, alpha: 0.19)
    
}
