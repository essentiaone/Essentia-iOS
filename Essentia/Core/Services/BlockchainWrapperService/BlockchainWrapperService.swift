//
//  BlockchainWrapperService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaBridgesApi

fileprivate struct Constants {
    static var url = "https://b3.essentia.network"
    static var apiVersion = "/api/v1"
    static var serverUrl = url + apiVersion
    static var ethterScanApiKey = ""
}

class BlockchainWrapperService: BlockchainWrapperServiceInterface {
    private var cryptoWallet: CryptoWallet
    
    init() {
        cryptoWallet = CryptoWallet(bridgeApiUrl: Constants.serverUrl, etherScanApiKey: Constants.ethterScanApiKey)
    }
    
    func getBalance(for coin: Coin, address: String, balance: @escaping (Double) -> Void) {
        switch coin {
        case .bitcoin:
            cryptoWallet.bitcoin.getBalance(for: address) { (result) in
                switch result {
                case .success(let obect):
                    balance(obect.balance.value)
                default: return
                }
            }
        case .ethereum:
            cryptoWallet.ethereum.getBalance(for: address) { (result) in
                switch result {
                case .success(let obect):
                    balance(obect.balance.value)
                default: return
                }
            }
        case .bitcoinCash:
            cryptoWallet.bitcoinCash.getBalance(for: address) { (result) in
                switch result {
                case .success(let obect):
                    balance(obect.result)
                default: return
                }
            }
        case .litecoin:
            cryptoWallet.litecoin.getBalance(for: address) { (result) in
                switch result {
                case .success(let obect):
                    balance(obect.balance.value)
                default: return
                }
            }
        }
    }

    func getBalance(for token: Token, address: String, balance: @escaping (Double) -> Void) {
//        cryptoWallet.
    }
}
