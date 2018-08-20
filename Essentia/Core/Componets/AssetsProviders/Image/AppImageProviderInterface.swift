//
//  AppImageProviderInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol AppImageProviderInterface {
    var backButtonImage: UIImage { get }
    var warningPrivacyIcon: UIImage { get }
    var checkInfoIcon: UIImage { get }
    var launchpadIcon: UIImage { get }
    var notificationsIcon: UIImage { get }
    var walletIcon: UIImage { get }
    var settingsIcon: UIImage { get }
    var languageIcon: UIImage { get }
    var currencyIcon: UIImage { get }
    var securityIcon: UIImage { get }
    var darkThemeIcon: UIImage { get }
    var feedbackIcon: UIImage { get }
    var testAvatarIcon: UIImage { get }
    var backWhiteIcon: UIImage { get }
    var checkBoxEmpty: UIImage { get }
    var checkBoxFilled: UIImage { get }
    var darkDotIcon: UIImage { get }
}
