//
//  WalletRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import QRCodeReader

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
        case .sendTransactionDetail(let wallet, let ammount):
            push(vc: SendTransactionDetailViewController(wallet: wallet, ammount: ammount))
        case .enterTransactionAmmount(let wallet):
            push(vc: EnterTransactionAmmountViewController(wallet: wallet))
        case .transactionDetail(let asset, let txId):
            showTransactionDetail(asset: asset, txId: txId)
        case .qrReader(let delegate):
            let builder = QRCodeReaderViewControllerBuilder { (config) in
                config.cancelButtonTitle = LS("Back")
                config.showCancelButton = true
                config.handleOrientationChange = false
                config.showTorchButton = true
                config.showOverlayView = true
            }
            let vc = QRCodeReaderViewController(builder: builder)
            vc.delegate = delegate
            popUp(vc: vc)
        case .walletOptions(let wallet):
            popUp(vc: WalletOptionsViewController(wallet: wallet))
        case .receive(let wallet):
            push(vc: WallerReceiveViewController(wallet: wallet))
        case .enterReceiveAmmount(let asset, let action):
            push(vc: WalletEnterReceiveAmmount(asset: asset, ammountCallback: action))
        }

    }
    private func showTransactionDetail(asset: AssetInterface, txId: String) {
        var url: URL?
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
