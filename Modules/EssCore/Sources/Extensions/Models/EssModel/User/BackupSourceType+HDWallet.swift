//
//  BackupSourceType+HDWallet.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/1/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import HDWalletKit
import EssResources
import EssModel

public extension BackupSourceType {
    public func derivationNodesFor(coin: HDWalletKit.Coin) -> [DerivationNode] {
        switch coin {
        case .bitcoin:
            return [.hardened(44), .hardened(0), .hardened(0), .notHardened(0)]
        case .ethereum:
            return [.hardened(44), .hardened(60), .hardened(0), .notHardened(0)]
        case .litecoin:
            return [.hardened(44), .hardened(2), .hardened(0), .notHardened(0)]
        case .bitcoinCash:
            return [.hardened(44), .hardened(145), .hardened(0), .notHardened(0)]
        }
    }
    
    public var title: String {
        switch self {
        case .app:
            return "Import from Essentia App"
        case .web:
            return "Import from Essentia Web"
        case .exodus:
            return "Import from Exodus"
        case .jaxx:
            return "Import from Jaxx"
        case .metaMask:
            return "Import from MetaMask"
        case .wallet:
            return "Import from Wallet"
        }
    }
}
