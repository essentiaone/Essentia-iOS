//
//  GeneratingWalletInfo.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct GeneratingWalletInfo: Codable {
    var name: String
    var coin: Coin
    var derivationIndex: UInt32
}
