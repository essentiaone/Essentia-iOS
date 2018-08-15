//
//  SettingsRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SettingsRouter: SettingsRouterInterface {
    let navigationController: UINavigationController
    
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
        default:
            return
        }
    }
    
    private func push(vc: UIViewController) {
        navigationController.pushViewController(vc, animated: true)
    }
    
    func pop() {
        navigationController.popViewController(animated: true)
    }
    
    private func showBackupRoute(type: BackupType) {
        prepareInjection(BackupRouter(navigationController: navigationController, mnemonic: "duty stable equal capable scrap suffer field penalty aspect hazard awake stand dilemma ancient unknown", type: type) as BackupRouterInterface, memoryPolicy: .viewController)
    }
}
