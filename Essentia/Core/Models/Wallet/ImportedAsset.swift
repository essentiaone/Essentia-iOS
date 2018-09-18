//
//  ImportedWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct ImportedWallet: Codable, WalletInterface {
    var coin: Coin
    var pk: String
    var name: String
}
