//
//  SettingsRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssUI
import EssDI

class SettingsRouter: BaseRouter, SettingsRouterInterface {
    func show(_ route: SettingsRoutes) {
        switch route {
        case .accountStrength:
            push(vc: SecureAccountViewController())
        case .currency:
            push(vc: SettingsCurrencyViewController())
        case .language:
            push(vc: SettingsLanguageViewController())
        case .switchAccount(let delegate):
            popUp(vc: SelectAccoutViewController(delegate))
        case .security:
            push(vc: SettingsSecurityViewController())
        case .backup(let type):
            guard let delegate = navigationController?.viewControllers.first as? SelectAccountDelegate else { return }
            showBackupRoute(type: type, delegate: delegate)
        case .accountName:
            push(vc: SettingsEditUserViewController())
        case .fullSecured:
            push(vc: FullSecuredViewController())
        }
    }
    
    func logOut(finish: @escaping () -> Void) {
        let root = UIApplication.shared.keyWindow?.rootViewController as? WelcomeViewController
        root?.dismiss(animated: true, completion: {
            finish()
        })
        root?.showFlipAnimation()
    }
    
    var nvc: UINavigationController? {
        return navigationController
    }
    
    private func showBackupRoute(type: BackupType, delegate: SelectAccountDelegate) {
        guard let navigation = navigationController else {
                return
        }
        prepareInjection(AuthRouter(navigationController: navigation,
                                    type: type,
                                    auth: .backup,
                                    delegate: delegate,
                                    sourceType: .app) as AuthRouterInterface, memoryPolicy: .viewController)
    }
}
