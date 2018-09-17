//
//  WalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol WalletInterface: Codable {
    var pk: String { get }
    var coin: Coin { get }
    var name: String { get }
}
