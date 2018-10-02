//
//  TokenWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct TokenAsset: Codable, ViewWalletInterface {
    var token: Token
    var wallet: GeneratingWalletInfo
    
    var name: String {
        return token.name
    }
    
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: name, size: .x128).url
    }
    
    var symbol: String {
        return token.symbol
    }
    
    var balanceInCurrentCurrency: String {
        return "$ 0.0"
    }
    
    var balance: String {
        return "0.0 " + token.symbol
    }
}
