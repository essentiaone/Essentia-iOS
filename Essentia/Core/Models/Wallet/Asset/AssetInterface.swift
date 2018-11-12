//
//  AssetInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.09.18
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum CryptoType {
    case coin
    case token
}

enum CurrencyType {
    case fiat
    case crypto
    
    var another: CurrencyType {
        switch self {
        case .fiat:
            return .crypto
        case .crypto:
            return .fiat
        }
    }
}

protocol AssetInterface {
    var name: String { get }
    var symbol: String { get }
    var iconUrl: URL { get }
    var type: CryptoType { get }
    
    func isValidAddress(_ address: String) -> Bool
}

extension AssetInterface where Self: Hashable {
    var hashValue: Int {
        return name.djb2hash
    }
}

extension AssetInterface {
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: name, size: .x128).url
    }
}
