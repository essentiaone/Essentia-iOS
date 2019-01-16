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
    static var appLightGreen = #colorLiteral(red: 0.231372549, green: 0.8117647059, blue: 0.3333333333, alpha: 1) //RGB(59,207,85)
    static var appDarkBlueOpacity = #colorLiteral(red: 0, green: 0.1176470588, blue: 1, alpha: 0.19) //RGB(0, 30, 255, alpha: 0.19)
    static var appLightBlueOpacity =  #colorLiteral(red: 0.1333333333, green: 0.3607843137, blue: 1, alpha: 0.31) //RGB(34, 92, 255, alpha: 0.31)
    static var appLightBlueWithoutOpacity =  #colorLiteral(red: 0.1333333333, green: 0.3607843137, blue: 1, alpha: 1) //RGB(34, 92, 255)
    
    static var appWhiteColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // .white
    static var appDarkTextColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1) // .darkText
    static var appSemiDarkColor = #colorLiteral(red: 0.07450980392, green: 0.1019607843, blue: 0.137254902, alpha: 1)//RGB(19, 26, 35)
    static var appDarkGrayOpacity = #colorLiteral(red: 0.5764705882, green: 0.6431372549, blue: 0.7490196078, alpha: 0.5241252201) //RGB(147, 164, 191, 0.5)
    static var appRedColor = #colorLiteral(red: 1, green: 0.2196078431, blue: 0, alpha: 1) //RGB(255, 56, 0)
    static var appDarkRedColor = #colorLiteral(red: 0.8156862745, green: 0.007843137255, blue: 0.1058823529, alpha: 1) //RGB(208, 2, 27)
    static var appWhiteWithLightBlue = #colorLiteral(red: 0.9294117647, green: 0.9490196078, blue: 0.9803921569, alpha: 1) //RGB(237, 242, 250)
    static var appOrageColor = #colorLiteral(red: 1, green: 0.631372549, blue: 0, alpha: 1) //RGB(255,161,0)
    static var shadowColor = #colorLiteral(red: 0.07843137255, green: 0.137254902, blue: 0.3019607843, alpha: 1) //RGB(20,35,77)
}

public struct DefaultColorSheme: AppColorInterface {
    public init() {}
    public var appBackgroundColor: UIColor = Constants.appWhiteColor
    public var appTitleColor: UIColor = Constants.appDarkTextColor
    public var appDefaultTextColor: UIColor = Constants.appLightGray
    public var appLinkTextColor: UIColor = Constants.appDarkGray
    // MARK: - Backup
    public var centeredButtonBackgroudColor: UIColor = Constants.appDarkBlue
    public var centeredButtonDisabledBackgroudColor: UIColor = Constants.appLigntLightGray
    public var centeredButtonTextColor: UIColor = Constants.appWhiteColor
    public var borderedButtonTextColor: UIColor = Constants.appDarkBlue
    public var borderedButtonBorderColor: UIColor = Constants.appDarkBlueOpacity
    public var copyButtonBackgroundSelectedColor: UIColor = Constants.appGreen
    public var copyButtonBackgroundDeselectedColor: UIColor = Constants.appDarkBlue
    public var copyButtonTextColor: UIColor = Constants.appWhiteColor
    public var blueBorderColor: UIColor = Constants.appLightBlueOpacity
    public var currentWordEmpty: UIColor = Constants.appLigntLightGray
    public var currentWordSelected: UIColor = Constants.appDarkGray
    public var currentWordCurrent: UIColor = Constants.appDarkBlue
    public var currentWordEnteringString: UIColor = Constants.appDarkTextColor
    public var currentWordEnteringPlaceholder: UIColor = Constants.appLigntLightGray
    public var enteredWordBackgroud: UIColor = Constants.appDarkBlue
    public var enteredWordText: UIColor = Constants.appWhiteColor
    public var validPasswordIndicator: UIColor = Constants.appGreen
    public var notValidPasswordIndicator: UIColor = Constants.appLigntLightGray
    
    // MARK: - Launchpad
    public var launchpadItemTitleColor: UIColor = Constants.appSemiDarkColor
    public var launchpadItemSubTitleColor: UIColor = Constants.appDarkGray
    // MARK: - TableViewAdapter
    public var settingsCellsBackround: UIColor = Constants.appWhiteColor
    public var separatorBackgroundColor: UIColor = Constants.appDarkGrayOpacity
    public var titleColor: UIColor = Constants.appDarkTextColor
    public var accountStrengthContainerViewBackgroudLowSecure: UIColor = Constants.appRedColor
    public var accountStrengthContainerViewBackgroudMediumSecure: UIColor = Constants.appOrageColor
    public var accountStrengthContainerViewBackgroudHightSecure: UIColor = Constants.appGreen
    public var accountStrengthContainerViewTitles: UIColor = Constants.appWhiteColor
    public var accountStrengthContainerViewButtonTitle: UIColor = Constants.appDarkTextColor
    public var settingsMenuTitle: UIColor = Constants.appDarkTextColor
    public var settingsMenuSubtitle: UIColor = Constants.appLightGray
    public var settingsMenuSwitchAccount: UIColor = Constants.appLightBlue
    public var settingsMenuLogOut: UIColor = Constants.appDarkRedColor
    public var settingsBackgroud: UIColor = Constants.appWhiteWithLightBlue
    public var settingsShadowColor: UIColor = Constants.shadowColor
    public var balanceChangedPlus: UIColor = Constants.appLightGreen
    public var balanceChangedMinus: UIColor = Constants.appRedColor
    public var balanceChanged: UIColor = Constants.appLightGray
    public var segmentControlIndicatorColor: UIColor = Constants.appLightBlueWithoutOpacity
}
