//
//  ImportedWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
public class ImportedWallet: Object {
    dynamic public var address: String = ""
    dynamic public var coin: Coin = .bitcoin
    dynamic public var encodedPk: Data = Data()
    dynamic public var name: String = ""
    dynamic public var lastBalance: Double = 0
    
    public convenience init(address: String, coin: Coin, encodedPk: Data, name: String, lastBalance: Double) {
        self.init()
        self.address = address
        self.coin = coin
        self.encodedPk = encodedPk
        self.name = name
        self.lastBalance = lastBalance
    }
}
