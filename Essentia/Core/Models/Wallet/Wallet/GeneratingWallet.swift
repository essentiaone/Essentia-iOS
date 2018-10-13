//
//  GeneratedWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct GeneratedWallet: Hashable, WalletInterface, ViewWalletInterface {
    var name: String
    var pk: String
    var address: String
    var coin: Coin
    var derivationIndex: UInt32
    var lastBalance: Double?
    
    init(name: String, pk: String, address: String, coin: Coin, derivationIndex: UInt32, lastBalance: Double? = nil) {
        self.name = name
        self.pk = pk
        self.address = address
        self.coin = coin
        self.derivationIndex = derivationIndex
        self.lastBalance = lastBalance
    }
    
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: name, size: .x128).url
    }
    
    var symbol: String {
        return coin.symbol
    }
    
    var asset: AssetInterface {
        return coin
    }
}
