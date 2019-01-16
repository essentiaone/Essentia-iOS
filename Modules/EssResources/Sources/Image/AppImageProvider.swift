//
//  AppImageProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public class AppImageProvider: AppImageProviderInterface {
    static var bandle = Bundle(identifier: "Essentia.EssResources")
    public init() {}
    public var backButtonImage: UIImage = image(name: "backButton")
    public var warningPrivacyIcon: UIImage = image(name: "warningPrivacy")
    public var checkInfoIcon: UIImage = image(name: "InfoCheckIcon")
    public var launchpadIcon: UIImage = image(name: "tabBarLaunchpad")
    public var notificationsIcon: UIImage = image(name: "tabBarNotifications")
    public var walletIcon: UIImage = image(name: "tabBarWallet")
    public var settingsIcon: UIImage = image(name: "tabBarSettings")
    public var languageIcon: UIImage = image(name: "settingsLanguage")
    public var currencyIcon: UIImage = image(name: "settingsCurrency")
    public var securityIcon: UIImage = image(name: "settingsSecurity")
    public var darkThemeIcon: UIImage = image(name: "SettingsTheme")
    public var feedbackIcon: UIImage = image(name: "settingsFeedback")
    public var testAvatarIcon: UIImage = image(name: "testAvatar")
    public var backWhiteIcon: UIImage = image(name: "backWhite")
    public var checkBoxEmpty: UIImage = image(name: "checkBoxEmpty")
    public var checkBoxFilled: UIImage = image(name: "checkBoxFilled")
    public var darkDotIcon: UIImage = image(name: "darkDot")
    public var checkIcon: UIImage = image(name: "check")
    public var cancelIcon: UIImage = image(name: "cancelIcon")
    public var plusIcon: UIImage = image(name: "greenPlusIcon")
    public var notificationPlaceholderIcon: UIImage = image(name: "notificationPlaceholder")
    public var warningIcon: UIImage = image(name: "warningIcon")
    public var mnemonicWaringIcon: UIImage = image(name: "warningMnemonicIcon")
    public var mnemonicIcon: UIImage = image(name: "mnemonicIcon")
    public var seedIcon: UIImage = image(name: "seedIcon")
    public var keystoreIcon: UIImage = image(name: "keystoreIcon")
    public var testAvatar: UIImage = image(name: "testAvatar")
    public var shareIcon: UIImage = image(name: "shareIcon")
    public var clearTextField: UIImage = image(name: "clearTextField")
    public var topAlertInfo: UIImage = image(name: "topAlertInfo")
    public var topAlertCancel: UIImage = image(name: "topAlertCancel")
    // MARK: - Wallet
    public var welcomeParagraph1: UIImage = image(name: "paragraph1")
    public var welcomeParagraph2: UIImage = image(name: "paragraph2")
    public var welcomeParagraph3: UIImage = image(name: "paragraph3")
    public var walletPlaceholder: UIImage = image(name: "walletMainPlaceholder")
    public var bluePlus: UIImage = image(name: "bluePlusIcon")
    public var bitcoinIcon: UIImage = image(name: "bitcoin")
    public var litecoinIcon: UIImage = image(name: "litecoin")
    public var ethereumIcon: UIImage = image(name: "ethereum")
    public var bitcoinCashIcon: UIImage = image(name: "bitcoinCash")
    public var checkSelected: UIImage = image(name: "walletCheckSelected")
    public var checkNotSelected: UIImage = image(name: "walletCheckNotSelected")
    public var qrCode: UIImage = image(name: "qrCode")
    public var launchpadPlaceholder: UIImage = image(name: "launchpadPlaceholder")
    public var upArrow: UIImage = image(name: "upArrow")
    public var arrowDown: UIImage = image(name: "arrowDown")
    public var passwordVisible: UIImage = image(name: "passwordVisible")
    // MARK: Transaction status
    public var txStatusSend: UIImage = image(name: "transactionSend")
    public var txStatusRecived: UIImage = image(name: "transactionRecived")
    public var txStatusPending: UIImage = image(name: "transactionWait")
    public var txStatusFailure: UIImage = image(name: "transactionFailed")
    public var txStatusExchang: UIImage = image(name: "transactionExchange")
    // MARK: - Options
    public var walletOptionsRename: UIImage = image(name: "optionsRename")
    public var walletOptionsExport: UIImage = image(name: "optionsExport")
    public var walletOptionsDelete: UIImage = image(name: "optionsDelete")
    
    public static func image(name: String) -> UIImage {
        return UIImage(named: name, in: bandle, compatibleWith: nil) ?? UIImage()
    }
}
