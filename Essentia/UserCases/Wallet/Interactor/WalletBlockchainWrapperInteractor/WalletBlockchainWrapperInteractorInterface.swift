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
import HDWalletKit

protocol WalletBlockchainWrapperInteractorInterface {
    func getCoinBalance(for coin: Coin, address: String, balance: @escaping (Double) -> Void)
    func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void)
    func getTokenTxHistory(address: Address, smartContract: Address, result: @escaping (NetworkResult<EthereumTokenTransactionByAddress>) -> Void)
    func getTxHistoryForBitcoinAddress(_ address: String, result: @escaping (NetworkResult<BitcoinTransactionsHistory>) -> Void)
    func getTxHistoryForEthereumAddress(_ address: String, result: @escaping (NetworkResult<EthereumTransactionsByAddress>) -> Void)
    func getTxHistory(for token: Token, address: String, balance: @escaping (Double) -> Void)
    
    func getGasSpeed(prices: @escaping (Double, Double, Double) -> Void)
    func getEthGasPrice(gasPrice: @escaping (Double) -> Void)
    func getEthGasEstimate(fromAddress: String, toAddress: String, data: String, gasLimit: @escaping (Double) -> Void)
    
    func txRawParametrs(for asset: AssetInterface, toAddress: String, ammountInCrypto: String, data: Data) throws -> (value: Wei, address: String, data: Data)
    func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (NetworkResult<String>) -> Void) throws
}
