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
    case seedCopy(seed: String)
    
    var controller: UIViewController {
        switch self {
        case .warning:
            return WarningViewContrller()
        case .phraseCopy(let mnemonic):
            return MnemonicPhraseCopyViewController(mnemonic: mnemonic)
        case .phraseConfirm(let mnemonic):
            return MnemonicPhraseConfirmViewController(mnemonic: mnemonic)
        case .seedCopy(let seed):
            return SeedCopyViewController(seed: seed)
        }
    }
}

class BackupRouter: BackupRouterInterface {
    let navigationController: UINavigationController
    fileprivate let routes: [BackupRoutes]
    var current: Int = 0
    required init(rootController: UIViewController, mnemonic: String, type: BackupType) {
        navigationController = UINavigationController(rootViewController: WarningViewContrller())
        navigationController.setNavigationBarHidden(true, animated: false)
        rootController.present(navigationController, animated: true)
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
                 .seedCopy(seed: (inject() as MnemonicProviderInterface).seed(from: mnemonic))
            ]
        default:
            routes = []
        }
    }
    
    func showNext() {
        current += 1
        print("Showing next. Current is \(current)")
        guard current != routes.count else {
            relese(self as BackupRouterInterface)
            return
        }
        let nextController = routes[current].controller
        navigationController.pushViewController(nextController, animated: true)
    }
    
    func showPrev() {
        current -= 1
        print("Showing prev. Current is \(current)")
        navigationController.popViewController(animated: true)
        guard current >= 0 else {
            navigationController.dismiss(animated: true)
            relese(self as BackupRouterInterface)
            return
        }
    }
}
