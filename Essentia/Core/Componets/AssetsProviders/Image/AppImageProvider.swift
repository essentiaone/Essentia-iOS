//
//  AppImageProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class AppImageProvider: AppImageProviderInterface {
    var backButtonImage: UIImage = #imageLiteral(resourceName: "backButton")
    var warningPrivacyIcon: UIImage = #imageLiteral(resourceName: "warningPrivacy")
    var checkInfoIcon: UIImage = #imageLiteral(resourceName: "InfoCheckIcon")
    var launchpadIcon: UIImage = #imageLiteral(resourceName: "tabBarLaunchpad")
    var notificationsIcon: UIImage = #imageLiteral(resourceName: "tabBarNotifications")
    var walletIcon: UIImage = #imageLiteral(resourceName: "tabBarWallet")
    var settingsIcon: UIImage = #imageLiteral(resourceName: "tabBarSettings")
}
