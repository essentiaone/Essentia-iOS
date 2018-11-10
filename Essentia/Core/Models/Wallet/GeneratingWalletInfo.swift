//
//  GeneratingWalletInfo.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct GeneratingWalletInfo: Hashable, Codable, AssetInterface {
    var name: String
    var coin: Coin
    var derivationIndex: UInt32
    
    var symbol: String {
        return coin.symbol
    }
    
    func isValidAddress(_ address: String) -> Bool {
        return coin.isValidAddress(address)
    }
}
