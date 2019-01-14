//
//  Coin+Localization.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel

extension Coin: AssetInterface {
    public var localizedName: String {
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
    
    public var name: String {
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
    
    public var symbol: String {
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
    
    public var shadowColor: UIColor {
        switch self {
        case .bitcoin:
            return RGB(246, 137, 35)
        case .ethereum:
            return .lightGray
        default: return .lightGray
        }
    }
    
    public func setIcon(in imageView: UIImageView) {
        imageView.image = icon
    }
    
    public var icon: UIImage {
        return UIImage()
//        let imageProvider = inject() as AppImageProviderInterface
//        switch self {
//        case .bitcoin:
//            return imageProvider.bitcoinIcon
//        case .ethereum:
//            return imageProvider.ethereumIcon
//        case .litecoin:
//            return imageProvider.litecoinIcon
//        case .bitcoinCash:
//            return imageProvider.bitcoinCashIcon
//        }
    }
    
    public func isValidAddress(_ address: String) -> Bool {
        switch self {
        case .bitcoin:
            return address.count > 27
        case .ethereum:
            return address.count > 40
        default:
            return true
        }
    }
    
    public static var allCases: [Coin] {
        return [.bitcoin, .ethereum, .litecoin, .bitcoinCash]
    }
    
    public var safeConfirmationCount: Int {
        switch self {
        case .bitcoin:
            return 3
        case .ethereum:
            return 7
        default:
            return 10
        }
    }
    
    public var type: CryptoType {
        return .coin
    }
    
    public func isSafeTransaction(confirmations: Int) -> Bool {
        return safeConfirmationCount < confirmations
    }
    
    public var iconUrl: URL {
        return CoinIconsUrlFormatter(name: name, size: .x128).url
    }
}
