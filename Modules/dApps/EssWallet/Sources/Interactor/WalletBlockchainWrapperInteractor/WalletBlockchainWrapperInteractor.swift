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
import EssCore
import EssModel
import EssDI

public class WalletBlockchainWrapperInteractor: WalletBlockchainWrapperInteractorInterface {
    private var cryptoWallet: CryptoWallet
    
    public init() {
        cryptoWallet = CryptoWallet(bridgeApiUrl: EssentiaConstants.bridgeUrl,
                                    etherScanApiKey: EssentiaConstants.ethterScanApiKey)
    }
    
    public func getCoinBalance(for coin: EssModel.Coin, address: String, balance: @escaping (Double) -> Void) {
        switch coin {
        case .bitcoin, .bitcoinCash, .litecoin, .dash:
            let utxoWallet = cryptoWallet.utxoWallet(coin: coin)
            utxoWallet.getBalance(for: address) { (result) in
                switch result {
                case .success(let obect):
                    balance(obect)
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
        }
    }
    
    public func getTokenBalance(for token: Token, address: String, balance: @escaping (Double) -> Void) {
        let erc20Token = ERC20(contractAddress: token.address, decimal: token.decimals, symbol: token.symbol)
        guard let data = try? erc20Token.generateGetBalanceParameter(toAddress: address) else {
            return
        }
        let smartContract = EthereumSmartContract(to: token.address, data: data.toHexString().addHexPrefix())
        cryptoWallet.ethereum.getTokenBalance(info: smartContract) { (result) in
            switch result {
            case .success(let object):
                guard let etherBalance = try? WeiEthterConverter.toToken(balance: object.balance, decimals: token.decimals, radix: 16) as NSDecimalNumber else {
                        return
                }
                balance(etherBalance.doubleValue)
            default: return
            }
        }
    }
    
    public func getTokenTxHistory(address: EssentiaBridgesApi.Address, smartContract: EssentiaBridgesApi.Address, result: @escaping (NetworkResult<EthereumTokenTransactionByAddress>) -> Void) {
        cryptoWallet.ethereum.getTokenTxHistory(for: address, smartContract: smartContract, result: result)
    }
    
    public func getTxHistoryForBitcoinAddress(_ address: String, result: @escaping (NetworkResult<UtxoTransactionsHistory>) -> Void) {
        cryptoWallet.bitcoin.getTransactionsHistory(for: address, result: result)
    }
    
    public func getTxHistoryForEthereumAddress(_ address: String, result: @escaping (NetworkResult<EthereumTransactionsByAddress>) -> Void) {
        cryptoWallet.ethereum.getTxHistory(for: address, result: result)
    }
    public func getGasSpeed(prices: @escaping (Double, Double, Double) -> Void) {
        cryptoWallet.ethereum.getGasSpeed { (result) in
            switch result {
            case .success(let object):
                let gasPrices = object.result
                prices(gasPrices.safeLow, gasPrices.average, gasPrices.fast)
            default: return
            }
        }
    }
    
    public func getEthGasPrice(gasPrice: @escaping (Double) -> Void) {
        cryptoWallet.ethereum.getGasPrice { (result) in
            switch result {
            case .success(let object):
                gasPrice(object.value)
            default: return
            }
        }
    }
    
    public func getEthGasEstimate(fromAddress: String, toAddress: String, data: String, gasLimit: @escaping (Double) -> Void) {
        cryptoWallet.ethereum.getGasEstimate(from: fromAddress, to: toAddress, data: data) { (result) in
            switch result {
            case .failure:
                (inject() as LoaderInterface).hide()
            case .success(let object):
                gasLimit(object.value)
            }
        }
    }
    
    public func txRawParametrs(for asset: AssetInterface, toAddress: String, ammountInCrypto: String, data: Data) throws -> (value: Wei, address: String, data: Data) {
        switch asset {
        case let token as Token:
            let value = Wei(integerLiteral: 0)
            let erc20Token = ERC20(contractAddress: token.address, decimal: token.decimals, symbol: token.symbol)
            let data = try Data(hex: erc20Token.generateSendBalanceParameter(toAddress: toAddress,
                                                                    amount: ammountInCrypto).toHexString().addHexPrefix())
            return (value: value, token.address, data: data)
        case is EssModel.Coin:
            let value = try WeiEthterConverter.toWei(ether: ammountInCrypto)
            let data = data
            return (value: value, address: toAddress, data: data)
        default: throw EssentiaError.unexpectedBehavior
        }
    }
    
    public func getTransactionsByWallet(_ wallet: EssModel.WalletInterface, transactions: @escaping ([ViewTransaction]) -> Void) {
        switch wallet.asset {
        case let token as Token:
            getTokenTxHistory(address: wallet.address, smartContract: token.address) { [unowned self] (result) in
                switch result {
                case .success(let tx):
                    transactions(self.mapTransactions(tx.result, address: wallet.address, forToken: token))
                case .failure(let error):
                    self.showError(error)
                }
            }
        case let coin as EssModel.Coin:
            switch coin {
            case .bitcoin, .bitcoinCash, .litecoin, .dash:
                let utxoWallet = cryptoWallet.utxoWallet(coin: coin)
                utxoWallet.getTransactionsHistory(for: wallet.address) { [unowned self] (result) in
                    switch result {
                    case .success(let tx):
                        transactions(self.mapTransactions(tx.items, address: wallet.address, asset: wallet.asset))
                    case .failure(let error):
                        self.showError(error)
                    }
                }
            case .ethereum:
                cryptoWallet.ethereum.getTxHistory(for: wallet.address) { [unowned self] (result) in
                    switch result {
                    case .success(let tx):
                        transactions(self.mapTransactions(tx.result, address: wallet.address, asset: wallet.asset))
                    case .failure(let error):
                        self.showError(error)
                    }
                }
            }
        default: return
        }
    }
    
    public func sendEthTransaction(wallet: ViewWalletInterface, transacionDetial: EtherTxInfo, result: @escaping (NetworkResult<String>) -> Void) throws {
        let txRwDetails = try txRawParametrs(for: wallet.asset,
                                             toAddress: transacionDetial.address,
                                             ammountInCrypto: transacionDetial.ammount.inCrypto,
                                             data: Data(hex: transacionDetial.data))
        cryptoWallet.ethereum.getTransactionCount(for: wallet.address) { (transactionCountResult) in
            switch transactionCountResult {
            case .success(let count):
                let transaction = EthereumRawTransaction(value: txRwDetails.value,
                                                         to: txRwDetails.address,
                                                         gasPrice: transacionDetial.gasPrice,
                                                         gasLimit: transacionDetial.gasLimit,
                                                         nonce: count.count,
                                                         data: txRwDetails.data)
                let dataPk = Data(hex: wallet.privateKey)
                let signer = EIP155Signer.init(chainId: 1)
                guard let txData = try? signer.sign(transaction, privateKey: dataPk) else {
                    result(.failure(.unknownError))
                    return
                }
                self.cryptoWallet.ethereum.sendTransaction(with: txData.toHexString().addHexPrefix(), result: {
                    switch $0 {
                    case .success(let object):
                        result(.success(object.txId))
                    case .failure(let error):
                        result(.failure(error))
                    }
                })
            default:
                result(.failure(.unknownError))
            }
            
        }
    }

    private func mapTransactions(_ transactions: [UtxoTransactionValue], address: String, asset: AssetInterface) -> [ViewTransaction] {
        return [ViewTransaction](transactions.map({
            let ammount = $0.transactionAmmount(for: address)
            let type = $0.type(for: address)
            return ViewTransaction(hash: $0.txid,
                                   address: $0.txid,
                                   ammount: CryptoFormatter.formattedAmmount(amount: ammount, type: type, asset: asset),
                                   status: $0.status,
                                   type: type,
                                   date: TimeInterval($0.time))
        }))
    }
    
    private func mapTransactions(
        _ transactions: [EthereumTransactionDetail],
        address: String,
        asset: AssetInterface) -> [ViewTransaction] {
        let nonTokenTx = transactions.filter({ return $0.value != "0" })
        return  [ViewTransaction](nonTokenTx.map({
            let txType = $0.type(for: address)
            let txAddress = txType == .recive ? $0.from : $0.to
            return ViewTransaction(
                hash: $0.hash,
                address: txAddress,
                ammount: CryptoFormatter.attributedHex(amount: $0.value, type: txType, asset: asset),
                status: $0.status,
                type: $0.type(for: address),
                date: TimeInterval($0.timeStamp) ?? 0)
        }))
    }
    
    private func mapTransactions(_ transactions: [EthereumTokenTransactionDetail], address: String, forToken: Token) -> [ViewTransaction] {
        return  [ViewTransaction](transactions.map({
            let txType = $0.type(for: address)
            let txAddress = txType == .recive ? $0.from : $0.to
            return ViewTransaction(
                hash: $0.hash,
                address: txAddress,
                ammount: CryptoFormatter.attributedHex(amount: $0.value, type: txType, decimals: forToken.decimals, asset: forToken),
                status: $0.status,
                type: $0.type(for: address),
                date: TimeInterval($0.timeStamp) ?? 0)
        }))
    }
    
    private func showError(_ error: EssentiaNetworkError) {
        (inject() as LoaderInterface).showError(error.localizedDescription)
    }
}
