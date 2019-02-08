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
    @objc dynamic private var privateCoin: String = "bitcoin"
    dynamic public var pk: String = ""
    dynamic public var name: String = ""
    dynamic public var lastBalance: Double = 0
    
    public var coin: Coin {
        set { privateCoin = newValue.rawValue }
        get { return Coin(rawValue: privateCoin)! }
    }
    
    public convenience init(address: String, coin: Coin, pk: String, name: String, lastBalance: Double) {
        self.init()
        self.address = address
        self.privateCoin = coin.rawValue
        self.pk = pk
        self.name = name
        self.lastBalance = lastBalance
    }
}
