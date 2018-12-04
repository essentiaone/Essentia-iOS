//
//  WalletRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import QRCodeReader
import EssentiaBridgesApi

enum WalletRoutes {
    case newAssets
    case selectImportAsset
    case importAsset(Coin)
    case failImportingAlert
    case succesImportingAlert
    case successGeneratingAlert
    case addAsset
    case selectEtherWallet(wallets: [ViewWalletInterface], action: (ViewWalletInterface) -> Void)
    case walletOptions(ViewWalletInterface)
    case walletDetail(ViewWalletInterface)
    case transactionDetailWeb(asset: AssetInterface, txId: String)
    case transactionDetail(viewTx: ViewTransaction, tx: EthereumTransactionDetail)
    case enterTransactionAmmount(ViewWalletInterface)
    case sendTransactionDetail(ViewWalletInterface, SelectedTransacrionAmmount)
    case qrReader(QRCodeReaderViewControllerDelegate)
    case receive(ViewWalletInterface)
    case enterReceiveAmmount(AssetInterface, action: (String) -> Void)
    case backupKeystore
    case doneTx
}

protocol WalletRouterInterface: BaseRouterInterface {
    func show(_ route: WalletRoutes)
}
