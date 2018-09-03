//
//  SettingsRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SettingsRouter: SettingsRouterInterface {
    weak var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func show(_ route: SettingsRoutes) {
        switch route {
        case .accountStrength:
            push(vc: SecureAccountViewController())
        case .backupMenmonic:
            showBackupRoute(type: .mnemonic)
        case .backupSeed:
            showBackupRoute(type: .seed)
        case .backupKeystore:
            showBackupRoute(type: .keystore)
        case .currency:
            push(vc: SettingsCurrencyViewController())
        case .language:
            push(vc: SettingsLanguageViewController())
        case .switchAccount(let callBack):
            popUp(vc: SwitchAccoutViewController(callBack))
        case .security:
            push(vc: SettingsSecurityViewController())
        case .backup(let type):
            showBackupRoute(type: type)
        case .activity(let fileUrl):
            popUp(vc: UIActivityViewController(activityItems: [fileUrl], applicationActivities: nil))
        case .loginType:
            push(vc: SettingsLoginMethodViewController())
        case .accountName:
            push(vc: SettingsEditUserViewController())
        }
    }
    
    private func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func popUp(vc: UIViewController) {
        navigationController?.present(vc, animated: true)
    }
    
    func logOut() {
        let root = UIApplication.shared.keyWindow?.rootViewController as? WelcomeViewController
        navigationController?.dismiss(animated: true)
        root?.showFlipAnimation()
    }
    
    private func showBackupRoute(type: BackupType) {
        guard let mnemonic = EssentiaStore.currentUser.mnemonic,
            let navigation = navigationController else {
                return
        }
        prepareInjection(AuthRouter(navigationController: navigation, mnemonic: mnemonic, type: type, auth: .backup) as AuthRouterInterface, memoryPolicy: .viewController)
    }
}
