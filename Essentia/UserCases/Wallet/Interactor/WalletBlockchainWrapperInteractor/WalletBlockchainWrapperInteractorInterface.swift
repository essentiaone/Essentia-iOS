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
    func getTokenTxHistory(address: Address, smartContract: Address, result: @escaping (Result<EthereumTokenTransactionByAddress>) -> Void) 
    func getTxHistoryForBitcoinAddress(_ address: String, result: @escaping (Result<BitcoinTransactionsHistory>) -> Void)
    func getTxHistoryForEthereumAddress(_ address: String, result: @escaping (Result<EthereumTransactionsByAddress>) -> Void)
    func getTxHistory(for token: Token, address: String, balance: @escaping (Double) -> Void)
    
    func getGasSpeed(prices: @escaping (Double, Double, Double) -> Void)
    func getEthGasPrice(gasPrice: @escaping (Double) -> Void)
    func getEthGasEstimate(fromAddress: String, toAddress: String, data: String, gasLimit: @escaping (Double) -> Void)
    
    func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (Result<String>) -> Void) throws
}
