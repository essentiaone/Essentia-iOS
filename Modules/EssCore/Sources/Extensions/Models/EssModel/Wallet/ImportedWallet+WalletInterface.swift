//
//  ImportedWallet.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import EssModel
import CryptoSwift
import HDWalletKit

extension ImportedWallet: WalletInterface, ViewWalletInterface {
    public convenience init(coin: EssModel.Coin, privateKey: String, name: String, lastBalance: Double) {
        let hdCoin: HDWalletKit.Coin = wrapCoin(coin: coin)
        let rawRrivateKey = PrivateKey(pk: privateKey, coin: hdCoin)
        let address = rawRrivateKey.publicKey.address
        self.init(address: address, coin: coin, privateKey: privateKey, name: name, lastBalance: lastBalance)
    }

    public var symbol: String {
        return coin.symbol
    }
    
    public var asset: AssetInterface {
        return coin
    }
}
