//
//  WalletRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class WalletRouter: BaseRouter, WalletRouterInterface {
    func show(_ route: WalletRoutes) {
        switch route {
        case .newAssets:
            push(vc: WalletNewAssetViewController())
        case .selectImportAsset:
            push(vc: WalletSelectImportAssetViewController())
        case .importAsset(let coin):
            push(vc: WalletImportAssetViewController(coin: coin))
        case .failImportingAlert:
            popUp(vc: FailImportingAlert(leftAction: {
                self.popToRoot()
            }, rightAction: {}))
        case .succesImportingAlert:
            popUp(vc: WalletDoneImportingAlert(okAction: {
                self.popToRoot()
            }))
        case .addAsset:
            push(vc: WalletCreateNewAssetViewController())
        }
    }
}
