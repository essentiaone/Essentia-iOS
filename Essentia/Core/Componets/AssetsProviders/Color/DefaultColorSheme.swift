//
//  DefaultColorSheme.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var appLightGray = RGB(98, 110, 126)
    static var appLigntLightGray = RGB(191, 201, 217)
    static var appDarkGray = RGB(147, 164, 191)
    static var appDarkBlue = RGB(0, 30, 255)
    static var appGreen = RGB(56, 191, 76)
    static var appDarkBlueOpacity = RGB(0, 30, 255, alpha: 0.19)
}

struct DefaultColorSheme: AppColorInterface {
    var appBackgroundColor: UIColor = .white
    var appTitleColor: UIColor = .darkText
    var appDefaultTextColor: UIColor = Constants.appLightGray
    var appLinkTextColor: UIColor = Constants.appDarkGray
    var centeredButtonBackgroudColor: UIColor = Constants.appDarkBlue
    var centeredButtonDisabledBackgroudColor: UIColor = Constants.appLigntLightGray
    var centeredButtonTextColor: UIColor = .white
    var borderedButtonTextColor: UIColor = Constants.appDarkBlue
    var borderedButtonBorderColor: UIColor = Constants.appDarkBlueOpacity
    var copyButtonBackgroundSelectedColor: UIColor = Constants.appGreen
    var copyButtonBackgroundDeselectedColor: UIColor = Constants.appDarkBlue
    var copyButtonTextColor: UIColor = .white
}
