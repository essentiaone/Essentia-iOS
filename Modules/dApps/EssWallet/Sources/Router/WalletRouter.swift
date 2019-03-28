//
//  WalletRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import QRCodeReader
import EssModel
import EssCore
import EssUI
import EssResources
import EssDI

public class WalletRouter: BaseRouter, WalletRouterInterface {

    private let tabBar: BaseTabBarController
    
    public required init(tabBarController: BaseTabBarController, nvc: BaseNavigationController) {
        tabBar = tabBarController
        super.init(navigationController: nvc)
    }
    
    required public init(navigationController: UINavigationController) {
        fatalError("init(navigationController:) has not been implemented")
    }
    
    public func show(_ route: WalletRoutes) {
        switch route {
        case .newAssets:
            popUp(vc: WalletNewAssetViewController())
        case .selectImportAsset:
            push(vc: WalletSelectImportAssetViewController())
        case .importAsset(let coin):
            push(vc: WalletImportAssetViewController(coin: coin))
        case .failImportingAlert:
            popUp(vc: FailImportingAlert(leftAction: { self.popToRoot() }, rightAction: {}))
        case .succesImportingAlert:
            popUp(vc: WalletDoneImportingAlert(okAction: { self.popToRoot() }))
        case .walletDeleted(let walletName):
            popUp(vc: WalletDeletedWarningViewController(walletName: walletName, okAction: { self.popToRoot() }))
        case .successGeneratingAlert:
            popUp(vc: WalletDoneGeneratingAlert(okAction: { self.popToRoot() }))
        case .addAsset(let assetType):
            push(vc: WalletCreateNewAssetViewController(defaultCryptoType: assetType))
        case .selectEtherWallet(let wallets, let action):
            popUp(vc: SelectWalletPopUp(wallets: wallets, didSelect: action))
        case .walletDetail(let wallet):
            push(vc: WalletDetailViewController(wallet: wallet))
        case .sendTransactionDetail(let wallet, let ammount):
            self.transactionDetail(wallet: wallet, ammount: ammount)
        case .enterTransactionAmmount(let wallet):
            push(vc: EnterTransactionAmmountViewController(wallet: wallet))
        case .transactionDetail(let asset, let txId):
            showTransactionDetail(asset: asset, txId: txId)
        case .qrReader(let delegate):
            showQrScaner(delegate: delegate)
        case .walletOptions(let wallet):
            popUp(vc: WalletOptionsViewController(wallet: wallet))
        case .receive(let wallet):
            push(vc: WallerReceiveViewController(wallet: wallet))
        case .enterReceiveAmmount(let asset, let action):
            push(vc: WalletEnterReceiveAmmount(asset: asset, ammountCallback: action))
        case .backupKeystore:
            self.showBackupKeystore()
        case .doneTx:
            push(vc: DoneTransactionViewController())
        }
    }
    
    private func showBackupKeystore() {
        tabBar.selectedViewController = (inject() as SettingsRouterInterface).nvc
        (inject() as SettingsRouterInterface).show(.security)
        (inject() as SettingsRouterInterface).show(.backup(type: .keystore))
    }
    
    private func transactionDetail(wallet: ViewWalletInterface, ammount: SelectedTransacrionAmmount) {
        switch wallet.asset {
        case let coin as Coin:
            switch coin {
            case .bitcoin:
                push(vc: SendBitcoinTransactionViewController(wallet: wallet, ammount: ammount))
            case .ethereum:
                push(vc: SendEthTransactionDetailViewController(wallet: wallet, ammount: ammount))
            default: return
            }
        case is Token:
            push(vc: SendEthTransactionDetailViewController(wallet: wallet, ammount: ammount))
        default: return
        }
    }
    
    private func showQrScaner(delegate: QRCodeReaderViewControllerDelegate) {
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
