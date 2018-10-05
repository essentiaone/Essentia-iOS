//
//  ImportedWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct ImportedWallet: Codable, WalletInterface, ViewWalletInterface {
    var address: String
    var coin: Coin
    var pk: String
    var name: String
    
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
