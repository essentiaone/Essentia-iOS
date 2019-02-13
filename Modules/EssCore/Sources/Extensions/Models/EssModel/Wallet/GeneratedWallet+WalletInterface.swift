//
//  GeneratedWallet+WalletInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel
import HDWalletKit
import EssDI

extension GeneratingWalletInfo: WalletInterface, ViewWalletInterface {
    public convenience init(name: String, coin: EssModel.Coin, derivationIndex: Int32) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let seed = EssentiaStore.shared.currentUser.seed
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
        let account = wallet.generateAccount(at: UInt32(derivationIndex))
        self.init(name: name, coin: coin, privateKey: account.rawPrivateKey, address: account.address, derivationIndex: derivationIndex, lastBalance: 0)
        self.coin = coin
        self.derivationIndex = derivationIndex
        self.lastBalance = 0
    }
    
    public var symbol: String {
        return coin.symbol
    }
    
    public func isValidAddress(_ address: String) -> Bool {
        return coin.isValidAddress(address)
    }
    
    public var asset: AssetInterface {
        return coin
    }
}
// ToDo: - Make single Coin model
func wrapCoin(coin: EssModel.Coin) -> HDWalletKit.Coin {
    switch coin {
    case .bitcoin:
        return HDWalletKit.Coin.bitcoin
    case .ethereum:
        return HDWalletKit.Coin.ethereum
    case .bitcoinCash:
        return HDWalletKit.Coin.bitcoinCash
    case .litecoin:
        return HDWalletKit.Coin.litecoin
    }
}
