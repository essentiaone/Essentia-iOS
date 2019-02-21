//
//  WalletInteractorInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

public protocol WalletInteractorInterface {
    func isValidWallet(_ wallet: ImportedWallet) -> Bool
    func getCoinsList() -> [Coin]
    func addCoinsToWallet(_ assets: [AssetInterface], wallet: @escaping (GeneratingWalletInfo) -> Void)
    func addTokensToWallet(_ assets: [AssetInterface], for wallet: ViewWalletInterface)
    func getGeneratedWallets() -> [GeneratingWalletInfo]
    func getImportedWallets() -> [ImportedWallet]
    func getTokensByWalleets() -> [String: [TokenWallet]]
    func getTotalBalanceInCurrentCurrency() -> Double
    func getYesterdayTotalBalanceInCurrentCurrency() -> Double
    func getBalanceChangePer24Hours(result: @escaping (Double) -> Void)
    func getBalanceChanging(olderBalance: Double, newestBalance: Double) -> Double
}
