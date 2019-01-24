//
//  GeneratingWalletInfo.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class GeneratingWalletInfo: Object {
    dynamic public var name: String = ""
    dynamic public var coin: Coin = .bitcoin
    dynamic public var derivationIndex: UInt32 = 0
    dynamic public var lastBalance: Double = 0
    
    public convenience init(name: String, coin: Coin, derivationIndex: UInt32, lastBalance: Double) {
        self.init()
        self.name = name
        self.coin = coin
        self.derivationIndex = derivationIndex
        self.lastBalance = lastBalance
    }
    
    static public func == (lhs: GeneratingWalletInfo, rhs: GeneratingWalletInfo) -> Bool {
        return lhs.coin == rhs.coin && lhs.derivationIndex == rhs.derivationIndex
    }
}
