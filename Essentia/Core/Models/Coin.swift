//
//  Coin.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum Coin: String, Codable {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash
    
    var name: String {
        switch self {
        case .bitcoin:
            return LS("Wallet.Bitcoin")
        case .ethereum:
            return LS("Wallet.Ethereum")
        case .litecoin:
            return LS("Wallet.Litecoin")
        case .bitcoinCash:
            return LS("Wallet.BitcoinCash")
        }
    }
    
    var icon: UIImage {
        let imageProvider = inject() as AppImageProviderInterface
        switch self {
        case .bitcoin:
            return imageProvider.bitcoinIcon
        case .ethereum:
            return imageProvider.ethereumIcon
        case .litecoin:
            return imageProvider.litecoinIcon
        case .bitcoinCash:
            return imageProvider.bitcoinCashIcon
        }
    }
    
    func isValidPK(_ pk: String) -> Bool {
        let regexString = "^[5KL][1-9A-HJ-NP-Za-km-z]{50,51}$"
        guard let regex = try? NSRegularExpression(pattern: regexString, options: .anchorsMatchLines),
            regex.firstMatch(in: pk, options: .anchored, range: .init(location: 0, length: pk.count)) != nil else {
                return false
        }
        return true
    }
    
    static var allCases: [Coin] {
        return [.bitcoin, .ethereum, .litecoin, .bitcoinCash]
    }
}
