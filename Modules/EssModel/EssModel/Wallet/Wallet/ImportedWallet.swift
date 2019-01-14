//
//  ImportedWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import HDWalletKit
import CryptoSwift

public class ImportedWallet: Codable {
    public var address: String
    public var coin: Coin
    public var encodedPk: Data
    public var name: String
    public var lastBalance: Double?
    
    public init(address: String, coin: Coin, encodedPk: Data, name: String, lastBalance: Double?) {
        self.address = address
        self.coin = coin
        self.encodedPk = encodedPk
        self.name = name
        self.lastBalance = lastBalance
    }
}
