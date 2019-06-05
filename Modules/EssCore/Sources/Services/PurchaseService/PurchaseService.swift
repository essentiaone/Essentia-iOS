//
//  PurchaseService.swift
//  EssCore
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import HDWalletKit
import EssentiaBridgesApi

public class PurchaseService: PurchaseServiceInterface {
    private let etherWallet: EthereumWallet
    
    public init() {
        let etherScanInfo = EtherScanInfo(url: EssentiaConstants.etherScanApiUrl, apiKey: EssentiaConstants.ethterScanApiKey)
        etherWallet = EthereumWallet(EssentiaConstants.bridgeUrl, etherScan: etherScanInfo)
    }
    
    public func getPurchaseType(for address: String, result: @escaping (PurchaseType) -> Void) {
        etherWallet.getTokenTxHistory(for: address,
                                      smartContract: EssentiaConstants.essentiaSmartContract) { (responce) in
                                        switch responce {
                                        case .success(let transactionsResultModel):
                                           let transactions = transactionsResultModel.result
                                           result(self.mapTransactions(transactions, address: address))
                                        case .failure(let error):
                                            result(.error(error))
                                        }
        }
    }
    
    private func mapTransactions(_ transactions: [EthereumTokenTransactionDetail], address: String) -> PurchaseType {
        let allTxAmmount = transactions.reduce(0.0, {
            let txValue = ((try? WeiEthterConverter.toToken(balance: $1.value, decimals: 18, radix: 10)) ?? 0) as NSDecimalNumber
            if address.lowercased() == $1.from {
                return $0 + txValue.doubleValue
            }
            return $0
        })
        let containUnlimitedAccount = transactions.contains {
            let txValue = ((try? WeiEthterConverter.toToken(balance: $0.value, decimals: 18, radix: 10)) ?? 0) as NSDecimalNumber
            return txValue.doubleValue >= PurchasePrice.unlimited.rawValue && $0.from.lowercased() == address
        }
        
        if containUnlimitedAccount {
            return .unlimited
        }
    
        if allTxAmmount < PurchasePrice.single.rawValue {
            return .notPurchased
        }
        
        let purchasedAccountsCount = Int(floor(allTxAmmount / PurchasePrice.single.rawValue))
        return .singeAccount(purchasedAccountsCount)
    }
}
