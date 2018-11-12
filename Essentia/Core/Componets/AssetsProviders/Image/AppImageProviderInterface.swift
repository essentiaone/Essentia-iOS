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
    var checkIcon: UIImage { get }
    var cancelIcon: UIImage { get }
    var plusIcon: UIImage { get }
    var notificationPlaceholderIcon: UIImage { get }
    var warningIcon: UIImage { get }
    var mnemonicWaringIcon: UIImage { get }
    var mnemonicIcon: UIImage { get }
    var seedIcon: UIImage { get }
    var keystoreIcon: UIImage { get }
    // MARK: - Wallet
    var welcomeParagraph1: UIImage { get }
    var welcomeParagraph2: UIImage { get }
    var welcomeParagraph3: UIImage { get }
    var walletPlaceholder: UIImage { get }
    var bluePlus: UIImage { get }
    var bitcoinIcon: UIImage { get }
    var litecoinIcon: UIImage { get }
    var ethereumIcon: UIImage { get }
    var bitcoinCashIcon: UIImage { get }
    var checkSelected: UIImage { get }
    var checkNotSelected: UIImage { get }
    // MARK: Transaction status
    var txStatusSend: UIImage { get }
    var txStatusRecived: UIImage { get }
    var txStatusPending: UIImage { get }
    var txStatusFailure: UIImage { get }
    var txStatusExchang: UIImage { get }
    // MARK: - Options
    var walletOptionsRename: UIImage { get }
    var walletOptionsExport: UIImage { get }
    var walletOptionsDelete: UIImage { get }
}
