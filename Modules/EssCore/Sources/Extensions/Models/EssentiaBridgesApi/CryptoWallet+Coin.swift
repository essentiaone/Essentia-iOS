//
//  CryptoWallet+Coin.swift
//  EssCore
//
//  Created by Pavlo Boiko on 5/14/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaBridgesApi
import EssModel

public extension CryptoWallet {
    func utxoWallet(coin: Coin) -> UtxoWalletUnterface {
        switch coin {
        case .bitcoin:
            return bitcoin
        case .bitcoinCash:
            return bitcoinCash
        case .litecoin:
            return litecoin
        case .dash:
            return dash
        case .essentia:
            return essentia
        default:
            fatalError("No such Utxo wallet!")
        }
    }
}
