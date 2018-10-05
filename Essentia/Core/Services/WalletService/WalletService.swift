//
//  WalletService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import HDWalletKit

class WalletService: WalletServiceInterface {
    func generateWallet(seed: Data, walletInfo: GeneratingWalletInfo) -> GeneratedWallet {
        let hdwalletCoin = wrapCoin(coin: walletInfo.coin)
        let wallet = Wallet(seed: seed, coin: hdwalletCoin)
        let account = wallet.generateAccount(at: walletInfo.derivationIndex)
        return GeneratedWallet(name: walletInfo.name,
                              pk: account.rawPrivateKey,
                              address: account.address,
                              coin: walletInfo.coin,
                              derivationIndex: walletInfo.derivationIndex)
    }
    
    private func wrapCoin(coin: Coin) -> HDWalletKit.Coin {
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
}
