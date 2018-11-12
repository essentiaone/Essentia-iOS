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
    var languageIcon: UIImage = #imageLiteral(resourceName: "settingsLanguage")
    var currencyIcon: UIImage = #imageLiteral(resourceName: "settingsCurrency")
    var securityIcon: UIImage = #imageLiteral(resourceName: "settingsSecurity")
    var darkThemeIcon: UIImage = #imageLiteral(resourceName: "SettingsTheme")
    var feedbackIcon: UIImage = #imageLiteral(resourceName: "settingsFeedback")
    var testAvatarIcon: UIImage = #imageLiteral(resourceName: "testAvatar")
    var backWhiteIcon: UIImage = #imageLiteral(resourceName: "backWhite")
    var checkBoxEmpty: UIImage = #imageLiteral(resourceName: "checkBoxEmpty")
    var checkBoxFilled: UIImage = #imageLiteral(resourceName: "checkBoxFilled")
    var darkDotIcon: UIImage = #imageLiteral(resourceName: "darkDot")
    var checkIcon: UIImage = #imageLiteral(resourceName: "check")
    var cancelIcon: UIImage = #imageLiteral(resourceName: "cancelIcon")
    var plusIcon: UIImage = #imageLiteral(resourceName: "greenPlusIcon")
    var notificationPlaceholderIcon: UIImage = #imageLiteral(resourceName: "notificationPlaceholder")
    var warningIcon: UIImage = #imageLiteral(resourceName: "warningIcon")
    var mnemonicWaringIcon: UIImage = #imageLiteral(resourceName: "warningMnemonicIcon")
    var mnemonicIcon: UIImage = #imageLiteral(resourceName: "mnemonicIcon")
    var seedIcon: UIImage = #imageLiteral(resourceName: "seedIcon")
    var keystoreIcon: UIImage = #imageLiteral(resourceName: "keystoreIcon")
    // MARK: - Wallet
    var welcomeParagraph1: UIImage = #imageLiteral(resourceName: "paragraph1")
    var welcomeParagraph2: UIImage = #imageLiteral(resourceName: "paragraph2")
    var welcomeParagraph3: UIImage = #imageLiteral(resourceName: "paragraph3")
    var walletPlaceholder: UIImage = #imageLiteral(resourceName: "walletMainPlaceholder")
    var bluePlus: UIImage = #imageLiteral(resourceName: "bluePlusIcon")
    var bitcoinIcon: UIImage = #imageLiteral(resourceName: "bitcoin")
    var litecoinIcon: UIImage = #imageLiteral(resourceName: "litecoin")
    var ethereumIcon: UIImage = #imageLiteral(resourceName: "ethereum")
    var bitcoinCashIcon: UIImage = #imageLiteral(resourceName: "bitcoinCash")
    var checkSelected: UIImage = #imageLiteral(resourceName: "walletCheckSelected")
    var checkNotSelected: UIImage = #imageLiteral(resourceName: "walletCheckNotSelected")
    // MARK: Transaction status
    var txStatusSend: UIImage = #imageLiteral(resourceName: "transactionSend")
    var txStatusRecived: UIImage = #imageLiteral(resourceName: "transactionRecived")
    var txStatusPending: UIImage = #imageLiteral(resourceName: "transactionWait")
    var txStatusFailure: UIImage = #imageLiteral(resourceName: "transactionFailed")
    var txStatusExchang: UIImage = #imageLiteral(resourceName: "transactionExchange")
    // MARK: - Options
    var walletOptionsRename: UIImage = #imageLiteral(resourceName: "optionsRename")
    var walletOptionsExport: UIImage = #imageLiteral(resourceName: "optionsExport")
    var walletOptionsDelete: UIImage = #imageLiteral(resourceName: "optionsDelete")
}
