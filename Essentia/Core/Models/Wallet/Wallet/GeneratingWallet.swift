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
    
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: name, size: .x128).url
    }
    
    var symbol: String {
        return coin.symbol
    }
    
    var balanceInCurrentCurrency: String {
        return "$ 0.0"
    }
    
    var balance: String {
        return "0.0 " + coin.symbol
    }
}
