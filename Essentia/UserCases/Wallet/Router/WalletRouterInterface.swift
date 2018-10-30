//
//  WalletRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum WalletRoutes {
    case newAssets
    case selectImportAsset
    case importAsset(Coin)
    case failImportingAlert
    case succesImportingAlert
    case addAsset
    case selectEtherWallet(wallets: [ViewWalletInterface], action: (ViewWalletInterface) -> Void)
    case walletDetail(ViewWalletInterface)
    case transactionDetail(asset: AssetInterface, txId: String)
}

protocol WalletRouterInterface: BaseRouterInterface {
    func show(_ route: WalletRoutes)
}
