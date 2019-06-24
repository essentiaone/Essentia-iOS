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

extension GeneratingWalletInfo: CoinWalletInterface {
    public convenience init(name: String, coin: EssModel.Coin, derivationIndex: Int32, seed: String, sourseType: BackupSourceType) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
    
        var walletDerivationNode = sourseType.derivationNodesFor(coin: wrapCoin(coin: coin))
        walletDerivationNode.append(.notHardened(UInt32(derivationIndex)))
        let account = wallet.generateAccount(at: walletDerivationNode)
        self.init(name: name, coin: coin, privateKey: account.rawPrivateKey, address: account.address, derivationIndex: derivationIndex, lastBalance: 0)
        self.coin = coin
        self.derivationIndex = derivationIndex
        self.lastBalance = 0
    }
    
    public convenience init(coin: EssModel.Coin, sourceType: BackupSourceType, seed: String) {
        let hdwalletCoin = wrapCoin(coin: coin)
        let wallet = Wallet(seed: Data(hex: seed), coin: hdwalletCoin)
        var coinDerivationNode = sourceType.derivationNodesFor(coin: hdwalletCoin)
        if sourceType != .web { coinDerivationNode.append(.notHardened(0)) }
        let account = wallet.generateAccount(at: coinDerivationNode)
        let index = coinDerivationNode.last!.index
        self.init(name: sourceType.name, coin: coin, privateKey: account.rawPrivateKey, address: account.address, derivationIndex: Int32(index), lastBalance: 0)
        self.coin = coin
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
public func wrapCoin(coin: EssModel.Coin) -> HDWalletKit.Coin {
    switch coin {
    case .bitcoin:
        return HDWalletKit.Coin.bitcoin
    case .ethereum:
        return HDWalletKit.Coin.ethereum
    case .bitcoinCash:
        return HDWalletKit.Coin.bitcoinCash
    case .litecoin:
        return HDWalletKit.Coin.litecoin
    case .dash:
        return .dash
    }
}
