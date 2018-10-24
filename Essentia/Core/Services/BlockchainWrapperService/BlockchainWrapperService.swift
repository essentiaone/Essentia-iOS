//
//  BlockchainWrapperService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaBridgesApi
import HDWalletKit

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
    
    func getBalance(for asset: AssetInterface, address: String, balance: @escaping (Double) -> Void) {
        switch asset {
        case let coin as Coin:
            getBalance(for: coin, address: address, balance: balance)
        case let token as Token:
            getBalance(for: token, address: address, balance: balance)
        default: return
        }
    }
    
    private func getBalance(for coin: Coin, address: String, balance: @escaping (Double) -> Void) {
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
    
    private func getBalance(for token: Token, address: String, balance: @escaping (Double) -> Void) {
        let erc20Token = ERC20(contractAddress: token.address, decimal: token.decimals, symbol: token.symbol)
        guard let data = try? erc20Token.generateGetBalanceParameter(toAddress: address) else {
            return
        }
        let smartContract = EthereumSmartContract(to: address, data: data.toHexString().addHexPrefix())
        cryptoWallet.ethereum.getTokenBalance(info: smartContract) { (result) in
            switch result {
            case .success(let object):
                guard let weiBalance = Wei(object.balance, radix: 16),
                    let etherBalance = try? WeiEthterConverter.toEther(wei: weiBalance) as NSDecimalNumber else {
                        return
                }
                balance(etherBalance.doubleValue)
            default: return
            }
        }
    }
}
