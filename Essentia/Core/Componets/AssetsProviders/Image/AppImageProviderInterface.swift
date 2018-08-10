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
}
