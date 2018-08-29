//
//  BackupRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate enum BackupRoutes {
    case warning
    case phraseCopy(mnemonic: String)
    case phraseConfirm(mnemonic: String)
    case seedCopy
    case keyStorePassword(mnemonic: String)
    case keyStoreWarning
    
    var controller: UIViewController {
        switch self {
        case .warning:
            return WarningViewContrller()
        case .phraseCopy(let mnemonic):
            return MnemonicPhraseCopyViewController(mnemonic: mnemonic)
        case .phraseConfirm(let mnemonic):
            return MnemonicPhraseConfirmViewController(mnemonic: mnemonic)
        case .seedCopy:
            return SeedCopyViewController(seed: EssentiaStore.currentUser.seed)
        case .keyStorePassword(let mnemonic):
            return KeyStorePasswordViewController(mnemonic: mnemonic)
        case .keyStoreWarning:
            return KeyStoreWarningViewController()
        }
    }
}

class BackupRouter: BackupRouterInterface {
    let navigationController: UINavigationController
    fileprivate let routes: [BackupRoutes]
    var current: Int = 0
    required init(navigationController: UINavigationController, mnemonic: String, type: BackupType) {
        self.navigationController = navigationController
        switch type {
        case .mnemonic:
            routes = [
                .warning,
                .phraseCopy(mnemonic: mnemonic),
                .phraseConfirm(mnemonic: mnemonic)
            ]
        case .seed:
            routes = [
                 .warning,
                 .seedCopy
            ]
        case .keystore:
            routes = [
                .keyStoreWarning,
                .keyStorePassword(mnemonic: mnemonic)
            ]
        default: routes = []
        }
        self.navigationController.pushViewController(routes.first!.controller, animated: true)
    }
    
    func showNext() {
        current++
        guard current != routes.count else {
            navigationController.popToRootViewController(animated: true)
            relese(self as BackupRouterInterface)
            return
        }
        let nextController = routes[current].controller
        navigationController.pushViewController(nextController, animated: true)
    }
    
    func showPrev() {
        current--
        navigationController.popViewController(animated: true)
        guard current >= 0 else {
            relese(self as BackupRouterInterface)
            return
        }
    }
}
