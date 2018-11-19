//
//  WalletInteractorInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol WalletInteractorInterface {
    func isValidWallet(_ wallet: ImportedWallet) -> Bool
    func getCoinsList() -> [Coin]
    func getTokensList(result: @escaping ([AssetInterface]) -> Void)
    @discardableResult func addCoinsToWallet(_ assets: [AssetInterface]) -> [GeneratingWalletInfo]
    func addTokensToWallet(_ assets: [AssetInterface], for wallet: GeneratingWalletInfo)
    func addTokensToWallet(_ assets: [AssetInterface])
    func getGeneratedWallets() -> [GeneratedWallet]
    func getImportedWallets() -> [ImportedWallet]
    func getTokensByWalleets() -> [GeneratingWalletInfo: [TokenWallet]]
    func getTotalBalanceInCurrentCurrency() -> Double
    func getYesterdayTotalBalanceInCurrentCurrency() -> Double
    func getBalanceChangePer24Hours(result: @escaping (Double) -> Void)
    func getBalanceChanging(olderBalance: Double, newestBalance: Double) -> Double
}
