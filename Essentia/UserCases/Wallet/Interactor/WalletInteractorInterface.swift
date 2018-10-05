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
    func getCoinsList() -> [AssetInterface]
    func getTokensList(result: @escaping ([AssetInterface]) -> Void)
    func addCoinsToWallet(_ assets: [AssetInterface])
    func addTokensToWallet(_ assets: [AssetInterface])
    func getGeneratedWallets() -> [GeneratedWallet]
    func getImportedWallets() -> [ImportedWallet]
    func getTokensByWalleets() -> [GeneratingWalletInfo : [TokenWallet]]
}
