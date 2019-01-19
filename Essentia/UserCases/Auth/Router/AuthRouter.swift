//
//  AuthRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssUI
import EssStore

fileprivate enum AuthRoutes {
    case warning
    case phraseCopy(mnemonic: String)
    case phraseConfirm(mnemonic: String)
    case mnemonicLogin(delegate: SelectAccountDelegate)
    case seedAuth(auth: AuthType, delegate: SelectAccountDelegate)
    case keyStorePassword(auth: AuthType, delegate: SelectAccountDelegate)
    case keyStoreWarning
    
    var controller: UIViewController {
        switch self {
        case .warning:
            return WarningViewContrller()
        case .phraseCopy(let mnemonic):
            return MnemonicPhraseCopyViewController(mnemonic: mnemonic)
        case .phraseConfirm(let mnemonic):
            return MnemonicPhraseConfirmViewController(mnemonic: mnemonic)
        case .seedAuth(let auth, let delegate):
            return SeedCopyViewController(auth, delegate: delegate)
        case .keyStorePassword(let auth, let delegate):
            return KeyStorePasswordViewController(auth, delegate: delegate)
        case .keyStoreWarning:
            return KeyStoreWarningViewController()
        case .mnemonicLogin(let delegate):
            return MnemonicPhraseConfirmViewController(delegate: delegate)
        }
    }
}

class AuthRouter: BaseRouter, AuthRouterInterface {
    fileprivate let routes: [AuthRoutes]
    var current: Int = 0
    required init(navigationController: UINavigationController, type: BackupType, auth: AuthType, delegate: SelectAccountDelegate) {
        switch auth {
        case .backup:
            switch type {
            case .mnemonic:
                guard let mnemonic = EssentiaStore.shared.currentCredentials.mnemonic else {
                    routes = []
                    break
                }
                routes = [
                    .warning,
                    .phraseCopy(mnemonic: mnemonic)
                ]
            case .seed:
                routes = [
                    .warning,
                    .seedAuth(auth:auth, delegate: delegate)
                ]
            case .keystore:
                routes = [
                    .keyStoreWarning,
                    .keyStorePassword(auth: auth, delegate: delegate)
                ]
            default: routes = []
            }
        case .login:
            switch type {
            case .mnemonic:
                routes = [
                    .mnemonicLogin(delegate: delegate)
                ]
            case .seed:
                routes = [
                    .seedAuth(auth:auth, delegate: delegate)
                ]
            case .keystore:
                routes = [
                    .keyStorePassword(auth: auth, delegate: delegate)
                ]
            default: routes = []
            }
        }
        super.init(navigationController: navigationController)
        guard let controller = routes.first?.controller else { return }
        push(vc: controller)
    }
    
    required init(navigationController: UINavigationController) {
        fatalError("init(navigationController:) has not been implemented")
    }
    
    func showNext() {
        current++
        guard current != routes.count else {
            popToRoot()
            relese(self as AuthRouterInterface)
            return
        }
        let nextController = routes[current].controller
        push(vc: nextController)
    }
    
    func showPrev() {
        current--
        if navigationController?.viewControllers.count == 1 {
            navigationController?.view.endEditing(true)
            navigationController?.dismiss(animated: true)
        } else {
            pop()
        }
        guard current >= 0 else {
            relese(self as AuthRouterInterface)
            return
        }
    }
}
