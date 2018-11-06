//
//  WalletBlockchainWrapperInteractor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaBridgesApi
import EssentiaNetworkCore
import HDWalletKit

fileprivate struct Constants {
    static var url = "https://b3.essentia.network"
    static var apiVersion = "/api/v1"
    static var serverUrl = url + apiVersion
    static var ethterScanApiKey = "IH2B5YWPTT3B19KMFYIFPMD85SQ7A12BDU"
}

class WalletBlockchainWrapperInteractor: WalletBlockchainWrapperInteractorInterface {
    private var cryptoWallet: CryptoWallet
    
    init() {
        cryptoWallet = CryptoWallet(bridgeApiUrl: Constants.serverUrl, etherScanApiKey: Constants.ethterScanApiKey)
    }
    
    func getCoinBalance(for coin: Coin, address: String, balance: @escaping (Double) -> Void) {
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
    
    func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void) {
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
    
    func getTxHistoryForBitcoinAddress(_ address: String, result: @escaping (Result<BitcoinTransactionsHistory>) -> Void) {
        cryptoWallet.bitcoin.getTransactionsHistory(for: address, result: result)
    }
    
    func getTxHistoryForEthereumAddress(_ address: String, result: @escaping (Result<EthereumTransactionsByAddress>) -> Void) {
        cryptoWallet.ethereum.getTxHistory(for: address, result: result)
    }
    
    func getTxHistory(for token: Token, address: String, balance: @escaping (Double) -> Void) {
        
    }
    
    func getEthGasPrice(gasPrice: @escaping (Double) -> Void) {
        cryptoWallet.ethereum.getGasPrice { (result) in
            switch result {
            case .success(let object):
                gasPrice(object.value)
            default: return
            }
        }
    }
    
    func getEthGasEstimate(fromAddress: String, toAddress: String , data: String, gasLimit: @escaping (Double) -> Void) {
        cryptoWallet.ethereum.getGasEstimate(from: fromAddress, to: toAddress, data: data) { (result) in
           print(result)
        }
    }
        
}
