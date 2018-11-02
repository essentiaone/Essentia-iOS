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
        case .selectEtherWallet(let wallets, let action):
            popUp(vc: SelectWalletPopUp(wallets: wallets, didSelect: action))
        case .walletDetail(let wallet):
            push(vc: WalletDetailViewController(wallet: wallet))
        case .enterTransactionAmmount(let wallet):
            push(vc: EnterTransactionAmmountViewController(wallet: wallet))
        case .transactionDetail(let asset, let txId):
            var url: URL? = nil
            switch asset {
            case let coin as Coin:
                switch coin {
                case .bitcoin:
                    url = URL(string: "https://www.blockchain.com/en/btc/tx/" + txId)
                case .ethereum:
                    url = URL(string: "https://etherscan.io/tx/" + txId)
                default: return
                }
            case is Token:
                url = URL(string: "https://etherscan.io/tx/" + txId)
            default: return
            }
            if url != nil {
                UIApplication.shared.open(url!, options: [:])
            }
        }
    }
}
