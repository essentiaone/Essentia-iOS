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
    @objc dynamic public var wallet: GeneratingWalletInfo? = GeneratingWalletInfo()
    @objc dynamic public var lastBalance: Double = 0
    
    public convenience init(name: String, token: Token, wallet: GeneratingWalletInfo, lastBalance: Double) {
        self.init()
        self.name = name
        self.token = token
        self.wallet = wallet
        self.lastBalance = lastBalance
    }
}
