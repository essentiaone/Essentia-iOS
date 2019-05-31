//
//  Coin.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public enum Coin: String, Equatable {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash
    case dash
    
    public static var fullySupportedCoins: [Coin] {
        return [.ethereum,
                .bitcoin,
                .bitcoinCash,
                .litecoin,
                .dash]
    }
    
    public func isValidPK(_ pk: String) -> Bool {
        return !pk.isEmpty
    }
    
    public var minimumTransactionAmmount: Double {
        switch self {
        case .bitcoin:
            return 0.000_005_46
        case .litecoin:
            return 0.000_01
        case .dash:
            return 0.000_01
        case .bitcoinCash:
            return 0.000_01
        default:
            return 1/pow(10, 18)
        }
    }
    
    func isValidAddress(_ address: String) -> Bool {
        switch self {
        case .bitcoin, .litecoin, .dash, .bitcoinCash:
            return address.count > 27
        case .ethereum:
            return address.count > 40
        }
    }
}
