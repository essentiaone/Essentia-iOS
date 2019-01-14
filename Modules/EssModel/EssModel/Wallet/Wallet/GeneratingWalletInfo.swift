//
//  GeneratingWalletInfo.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public class GeneratingWalletInfo: Hashable, Codable {
    public var name: String
    public var coin: Coin
    public var derivationIndex: UInt32
    public var lastBalance: Double?
    
    public init(name: String, coin: Coin, derivationIndex: UInt32, lastBalance: Double?) {
        self.name = name
        self.coin = coin
        self.derivationIndex = derivationIndex
        self.lastBalance = lastBalance
    }
    
    public var hashValue: Int {
        return 1
    }
    
    static public func == (lhs: GeneratingWalletInfo, rhs: GeneratingWalletInfo) -> Bool {
        return lhs.coin == rhs.coin && lhs.derivationIndex == rhs.derivationIndex
    }
}
