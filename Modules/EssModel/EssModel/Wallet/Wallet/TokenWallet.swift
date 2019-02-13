//
//  TokenWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

@objc
public class TokenWallet: Object {
    @objc dynamic public var name: String = ""
    @objc dynamic public var token: Token? = Token()
    @objc dynamic public var privateKey: String = ""
    @objc dynamic public var address: String = ""
    @objc dynamic public var lastBalance: Double = 0
    
    public convenience init(name: String, token: Token, privateKey: String, address: String, lastBalance: Double) {
        self.init()
        self.name = name
        self.token = token
        self.privateKey = privateKey
        self.address = address
        self.lastBalance = lastBalance
    }
}
