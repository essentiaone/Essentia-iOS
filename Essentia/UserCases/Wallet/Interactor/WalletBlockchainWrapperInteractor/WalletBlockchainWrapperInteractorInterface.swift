//
//  WalletBlockchainWrapperInteractorInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssentiaBridgesApi

protocol WalletBlockchainWrapperInteractorInterface {
    func getCoinBalance(for coin: Coin, address: String, balance: @escaping (Double) -> Void)
    func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void)
    func getTxHistoryForBitcoinAddress(_ address: String, result: @escaping (Result<BitcoinTransactionsHistory>) -> Void)
    func getTxHistoryForEthereumAddress(_ address: String, result: @escaping (Result<EthereumTransactionsByAddress>) -> Void)
    func getTxHistory(for token: Token, address: String, balance: @escaping (Double) -> Void)
    
    func getEthGasPrice(gasPrice: @escaping (Double) -> Void)
    func getEthGasEstimate(for address: String, data: String, gasLimit: @escaping (Double) -> Void)
}
