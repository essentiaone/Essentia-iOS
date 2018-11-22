//
//  Coin.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum Coin: String, Codable, AssetInterface {
    case bitcoin
    case ethereum
    case litecoin
    case bitcoinCash

    var localizedName: String {
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
    
    var name: String {
        switch self {
        case .bitcoin:
            return "Bitcoin"
        case .ethereum:
            return "Ethereum"
        case .litecoin:
            return "Litecoin"
        case .bitcoinCash:
            return "Bitcoin Cash"
        }
    }
    
    var symbol: String {
        switch self {
        case .bitcoin:
            return LS("Wallet.Bitcoin.Short")
        case .ethereum:
            return LS("Wallet.Ethereum.Short")
        case .litecoin:
            return LS("Wallet.Litecoin.Short")
        case .bitcoinCash:
            return LS("Wallet.BitcoinCash.Short")
        }
    }
    
    var shadowColor: UIColor {
        switch self {
        case .bitcoin:
            return RGB(246, 137, 35)
        case .ethereum:
            return .lightGray
        default: return .lightGray
        }
    }
    
    func setIcon(in imageView: UIImageView) {
        imageView.image = icon
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
    
    static var allCases: [Coin] {
        return [.bitcoin, .ethereum, .litecoin, .bitcoinCash]
    }
    
    var safeConfirmationCount: Int {
        switch self {
        case .bitcoin:
            return 3
        case .ethereum:
            return 7
        default:
            return 10
        }
    }
    
    var type: CryptoType {
        return .coin
    }
    
    func isSafeTransaction(confirmations: Int) -> Bool {
        return safeConfirmationCount < confirmations
    }
    
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: name, size: .x128).url
    }
}
