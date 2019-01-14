//
//  Coin.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

//enum Coin: String, Codable, AssetInterface {
public enum Coin: String, Codable {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash
    
    public func isValidPK(_ pk: String) -> Bool {
        return !pk.isEmpty
    }
    
    func isValidAddress(_ address: String) -> Bool {
        switch self {
        case .bitcoin:
            return address.count > 27
        case .ethereum:
            return address.count > 40
        default:
            return true
        }
    }
}
