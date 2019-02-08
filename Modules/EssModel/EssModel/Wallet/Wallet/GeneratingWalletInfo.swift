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
    public var coin: Coin {
        set { privateCoin = newValue.rawValue }
        get { return Coin(rawValue: privateCoin)! }
    }
    dynamic public var derivationIndex: Int32 = 0
    dynamic public var lastBalance: Double = 0
    @objc dynamic private var privateCoin: String = "bitcoin"
    
    public convenience init(name: String, coin: Coin, derivationIndex: Int32, lastBalance: Double) {
        self.init()
        self.name = name
        self.privateCoin = coin.rawValue
        self.derivationIndex = derivationIndex
        self.lastBalance = lastBalance
    }
    
    static public func == (lhs: GeneratingWalletInfo, rhs: GeneratingWalletInfo) -> Bool {
        return lhs.coin == rhs.coin && lhs.derivationIndex == rhs.derivationIndex
    }
}
