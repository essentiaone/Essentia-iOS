//
//  GeneratedWallet+WalletInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

extension GeneratingWalletInfo: WalletInterface, ViewWalletInterface {
    public func privateKey(withSeed: String) -> String? {
        return ""
//        return (inject() as  WalletServiceInterface).generatePk(self)
    }
    
    public convenience init(name: String, coin: Coin, derivationIndex: UInt32) {
        self.init(name: name, coin: coin, derivationIndex: derivationIndex, lastBalance: 0)
        self.coin = coin
        self.derivationIndex = derivationIndex
        self.lastBalance = nil
    }
    
    public var symbol: String {
        return coin.symbol
    }
    
    public func isValidAddress(_ address: String) -> Bool {
        return coin.isValidAddress(address)
    }
    
    public var hashValue: Int {
        return 1
    }
    
    public var asset: AssetInterface {
        return coin
    }
    
    public var address: String {
        return ""
//        return (inject() as  WalletServiceInterface).generateAddress(self)
    }
}
