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
    @objc dynamic public var privateCoin: String = "bitcoin"
    dynamic public var privateKey: String = ""
    dynamic public var address: String = ""
    dynamic public var name: String = ""
    dynamic public var lastBalance: Double = 0
    
    public var coin: Coin {
        set { privateCoin = newValue.rawValue }
        get { return Coin(rawValue: privateCoin)! }
    }
    
    public convenience init(address: String, coin: Coin, privateKey: String, name: String, lastBalance: Double) {
        self.init()
        self.address = address
        self.privateCoin = coin.rawValue
        self.privateKey = privateKey
        self.name = name
        self.lastBalance = lastBalance
    }
}
