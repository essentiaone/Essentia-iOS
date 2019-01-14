//
//  TokenWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public class TokenWallet: Codable {
    public var name: String
    public var token: Token
    public var wallet: GeneratingWalletInfo
    public var lastBalance: Double?
    
    public init(name: String, token: Token, wallet: GeneratingWalletInfo, lastBalance: Double?) {
        self.name = name
        self.token = token
        self.wallet = wallet
        self.lastBalance = lastBalance
    }
}
