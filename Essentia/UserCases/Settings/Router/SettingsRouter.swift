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
        }
    }
    
    private func push(vc: UIViewController) {
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    private func showBackupRoute(type: BackupType) {
        guard let mnemonic = EssentiaStore.currentUser.mnemonic,
              let navigation = navigationController else {
            return
        }
        prepareInjection(BackupRouter(navigationController: navigation, mnemonic: mnemonic, type: type) as BackupRouterInterface, memoryPolicy: .viewController)
    }
    
    func logOut() {
        let parent = navigationController?.parent as? WelcomeViewController
        navigationController?.dismiss(animated: true)
        parent?.showFlipAnimation()
    }
}
