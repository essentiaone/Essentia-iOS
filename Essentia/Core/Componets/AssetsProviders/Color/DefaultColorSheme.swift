//
//  DefaultColorSheme.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var appLightGray = #colorLiteral(red: 0.3843137255, green: 0.431372549, blue: 0.4941176471, alpha: 1) //RGB(98, 110, 126)
    static var appLigntLightGray = #colorLiteral(red: 0.7490196078, green: 0.7882352941, blue: 0.8509803922, alpha: 1) //RGB(191, 201, 217)
    static var appDarkGray = #colorLiteral(red: 0.5764705882, green: 0.6431372549, blue: 0.7490196078, alpha: 1) //RGB(147, 164, 191)
    static var appDarkBlue = #colorLiteral(red: 0, green: 0.1176470588, blue: 1, alpha: 1) //RGB(0, 30, 255)
    static var appLightBlue = #colorLiteral(red: 0.1764705882, green: 0.3921568627, blue: 0.9960784314, alpha: 1) //RGB(45, 100, 254)
    static var appGreen = #colorLiteral(red: 0.2196078431, green: 0.7490196078, blue: 0.2980392157, alpha: 1) //RGB(56, 191, 76)
    static var appDarkBlueOpacity = #colorLiteral(red: 0, green: 0.1176470588, blue: 1, alpha: 0.19) //RGB(0, 30, 255, alpha: 0.19)
    static var appLightBlueOpacity =  #colorLiteral(red: 0.1333333333, green: 0.3607843137, blue: 1, alpha: 0.31) //RGB(34, 92, 255, alpha: 0.31)
    static var appWhiteColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // .white
    static var appDarkTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // .darkText
    static var appSemiDarkColor = #colorLiteral(red: 0.07450980392, green: 0.1019607843, blue: 0.137254902, alpha: 1)//RGB(19, 26, 35)
    static var appDarkGrayOpacity = #colorLiteral(red: 0.5764705882, green: 0.6431372549, blue: 0.7490196078, alpha: 0.5241252201) //RGB(147, 164, 191, 0.5)
    static var appRedColor = #colorLiteral(red: 1, green: 0.2196078431, blue: 0, alpha: 1) //RGB(255, 56, 0)
    static var appDarkRedColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1) //RGB(208, 2, 27)
}

struct DefaultColorSheme: AppColorInterface {
    var appBackgroundColor: UIColor = Constants.appWhiteColor
    var appTitleColor: UIColor = Constants.appDarkTextColor
    var appDefaultTextColor: UIColor = Constants.appLightGray
    var appLinkTextColor: UIColor = Constants.appDarkGray
    // MARK: - Backup
    var centeredButtonBackgroudColor: UIColor = Constants.appDarkBlue
    var centeredButtonDisabledBackgroudColor: UIColor = Constants.appLigntLightGray
    var centeredButtonTextColor: UIColor = Constants.appWhiteColor
    var borderedButtonTextColor: UIColor = Constants.appDarkBlue
    var borderedButtonBorderColor: UIColor = Constants.appDarkBlueOpacity
    var copyButtonBackgroundSelectedColor: UIColor = Constants.appGreen
    var copyButtonBackgroundDeselectedColor: UIColor = Constants.appDarkBlue
    var copyButtonTextColor: UIColor = Constants.appWhiteColor
    var blueBorderColor: UIColor = Constants.appLightBlueOpacity
    var currentWordEmpty: UIColor = Constants.appLigntLightGray
    var currentWordSelected: UIColor = Constants.appDarkGray
    var currentWordCurrent: UIColor = Constants.appDarkBlue
    var currentWordEnteringString: UIColor = Constants.appDarkTextColor
    var currentWordEnteringPlaceholder: UIColor = Constants.appLigntLightGray
    var enteredWordBackgroud: UIColor = Constants.appDarkBlue
    var enteredWordText: UIColor = Constants.appWhiteColor
    // MARK: - Launchpad
    var launchpadItemTitleColor: UIColor = Constants.appSemiDarkColor
    var launchpadItemSubTitleColor: UIColor = Constants.appDarkGray
    // MARK: - TableViewAdapter
    var separatorBackgroundColor: UIColor = Constants.appDarkGrayOpacity
    var titleColor: UIColor = Constants.appDarkTextColor
    var accountStrengthContainerViewBackgroud: UIColor = Constants.appRedColor
    var accountStrengthContainerViewTitles: UIColor = Constants.appWhiteColor
    var settingsMenuTitle: UIColor = Constants.appDarkTextColor
    var settingsMenuSubtitle: UIColor = Constants.appLightGray
    var settingsMenuSwitchAccount: UIColor = Constants.appLightBlue
    var settingsMenuLogOut: UIColor = Constants.appDarkRedColor
}
