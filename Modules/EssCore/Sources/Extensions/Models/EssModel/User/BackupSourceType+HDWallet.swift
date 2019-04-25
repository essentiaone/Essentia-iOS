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
    func derivationNodesFor(coin: HDWalletKit.Coin) -> [DerivationNode] {
        switch coin {
        case .bitcoin:
            switch self {
            case .app:
                return [.hardened(0), .notHardened(1)]
            case .web:
                return [.notHardened(0), .notHardened(1)]
            default:
                return [.hardened(44), .hardened(0), .hardened(0), .notHardened(0)]
            }
        case .ethereum:
            switch self {
            case .app:
                return [.hardened(0), .notHardened(4)]
            case .web:
                return [.notHardened(0), .notHardened(0), .notHardened(1), .notHardened(2), .notHardened(3), .notHardened(4), .notHardened(5)]
            default:
                return [.hardened(44), .hardened(60), .hardened(0), .notHardened(0)]
            }
        case .litecoin:
            switch self {
            case .app:
                return [.hardened(0), .notHardened(5)]
            case .web:
                return [.notHardened(0), .notHardened(1)]
            default:
                return [.hardened(44), .hardened(2), .hardened(0), .notHardened(0)]
            }
        case .bitcoinCash:
            switch self {
            case .app:
                return [.hardened(0), .notHardened(2)]
            case .web:
                return [.notHardened(0), .notHardened(1)]
            default:
                return [.hardened(44), .hardened(145), .hardened(0), .notHardened(0)]
            }
        }
    }
    
    var title: String {
        return "Import from " + name
    }
    
    var name: String {
        switch self {
        case .app:
            return "Essentia App"
        case .web:
            return "Essentia Web"
        case .exodus:
            return "Exodus"
        case .jaxx:
            return "Jaxx"
        case .metaMask:
            return "MetaMask"
        case .wallet:
            return "Wallet"
        }
    }
}
