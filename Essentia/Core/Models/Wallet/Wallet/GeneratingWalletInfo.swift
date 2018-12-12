//
//  GeneratingWalletInfo.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class GeneratingWalletInfo: Hashable, Codable, ViewWalletInterface {
    var name: String
    var coin: Coin
    var derivationIndex: UInt32
    var lastBalance: Double?
    
    func privateKey(withSeed: String) -> String? {
        return (inject() as  WalletServiceInterface).generatePk(self)
    }
    
    init(name: String, coin: Coin, derivationIndex: UInt32) {
        self.name = name
        self.coin = coin
        self.derivationIndex = derivationIndex
    }
    
    var symbol: String {
        return coin.symbol
    }
    
    func isValidAddress(_ address: String) -> Bool {
        return coin.isValidAddress(address)
    }
    
    var hashValue: Int {
        return 1
    }
    
    var asset: AssetInterface {
        return coin
    }
    
    var address: String {
        return (inject() as  WalletServiceInterface).generateAddress(self)
    }
}

func == (lhs: GeneratingWalletInfo, rhs: GeneratingWalletInfo) -> Bool {
    return lhs.coin == rhs.coin && lhs.derivationIndex == rhs.derivationIndex
}
