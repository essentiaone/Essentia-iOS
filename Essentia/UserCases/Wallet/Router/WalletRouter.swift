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
        case .importAsset:
            push(vc: WalletImportAssetViewController())
        }
    }
}
