//
//  WalletService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import HDWalletKit
import EssModel

public class WalletService: WalletServiceInterface {
    public init() {}
    public func generateAccount(seed: Data, walletInfo: GeneratingWalletInfo) -> Account {
        let hdwalletCoin = wrapCoin(coin: walletInfo.coin)
        let wallet = Wallet(seed: seed, coin: hdwalletCoin)
        return wallet.generateAccount(at: walletInfo.derivationIndex)
    }
    
    private func wrapCoin(coin: EssModel.Coin) -> HDWalletKit.Coin {
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
    
    public func generateAddress(from pk: String, coin: EssModel.Coin) -> String {
        let coin: HDWalletKit.Coin = wrapCoin(coin: coin)
        let privateKey = PrivateKey(pk: pk, coin: coin)
        return privateKey.publicKey.address
    }
    
    public func generateAddress(_ walletInfo: GeneratingWalletInfo, seed: Data) -> String {
        let account = self.generateAccount(seed: seed, walletInfo: walletInfo)
        return account.address
    }
    
    public func generatePk(_ walletInfo: GeneratingWalletInfo, seed: Data) -> String {
        let account = self.generateAccount(seed: seed, walletInfo: walletInfo)
        return account.rawPrivateKey
    }
}
