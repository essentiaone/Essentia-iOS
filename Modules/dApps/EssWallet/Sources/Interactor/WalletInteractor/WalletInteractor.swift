//
//  WalletInteractor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssModel
import EssDI
import RealmSwift

public class WalletInteractor: WalletInteractorInterface {    
    private lazy var tokenService: TokensServiceInterface = inject()
    
    public init() {}
    
    public func isValidWallet(_ wallet: ImportedWallet) -> Bool {
        guard let importdAssets = EssentiaStore.shared.currentUser.wallet?.importedWallets else {
            return true
        }
        let alreadyContainWallet = importdAssets.contains {
            return $0.privateKey == wallet.privateKey
        }
        return !alreadyContainWallet
    }
    
    public func getCoinsList() -> [Coin] {
        return Coin.fullySupportedCoins
    }
    
    private func freeIndex(for coin: Coin) -> Int32 {
        guard let currentlyAddedWallets = EssentiaStore.shared.currentUser.wallet?.generatedWalletsInfo else { return 0 }
        let currentCoinAssets = currentlyAddedWallets.filter({ return $0.coin == coin })
        var index: Int32 = 0
        while index < Int32.max {
            if currentCoinAssets.contains(where: { return $0.derivationIndex == index }) {
                index += 1
                continue
            }
            return index
        }
        return index
    }
    
    public func addCoinsToWallet(_ assets: [AssetInterface], wallet: @escaping (GeneratingWalletInfo) -> Void) {
        guard let coins = assets as? [Coin],
              let currentlyAddedWallets = EssentiaStore.shared.currentUser.wallet?.generatedWalletsInfo else { return }
        coins.forEach { coin in
            let index = freeIndex(for: coin)
            let seed = EssentiaStore.shared.currentUser.seed
            let sourseType = EssentiaStore.shared.currentUser.wallet?.sourceType ?? .app
            let walletInfo = GeneratingWalletInfo(name: coin.localizedName,
                                                 coin: coin,
                                                 derivationIndex: index,
                                                 seed: seed,
                                                 sourseType: sourseType)
            (inject() as UserStorageServiceInterface).update({ _ in
                let address = walletInfo.address
                let generatedName = walletInfo.name + " " + address.suffix(4)
                walletInfo.name = generatedName
                currentlyAddedWallets.append(walletInfo)
            })
            wallet(walletInfo)
        }
        (inject() as UserStorageServiceInterface).update({ (user) in
            user.wallet?.generatedWalletsInfo = currentlyAddedWallets
        })
        (inject() as CurrencyRankDaemonInterface).update()
    }
    
    public func addTokensToWallet(_ assets: [AssetInterface], for wallet: ViewWalletInterface) {
        guard let tokens = assets as? [Token] else { return }
        let copyTokens = tokens.map ({ token -> Token in
            let iconsPath = TokenIcons(x16: token.path?.x16, x32: token.path?.x32, x64: token.path?.x64, x128: token.path?.x128)
            return Token(id: token.id, address: token.address, symbol: token.symbol, name: token.name, decimals: token.decimals, path: iconsPath)
        })
        copyTokens.forEach { token in
            (inject() as UserStorageServiceInterface).update({ (user) in
                let tokenAsset = TokenWallet(token: token, wallet: wallet, lastBalance: 0)
                user.wallet?.tokenWallets.append(tokenAsset)
            })
            (inject() as CurrencyRankDaemonInterface).update()
        }
    }
    
    public func getGeneratedWallets() -> [GeneratingWalletInfo] {
        return EssentiaStore.shared.currentUser.wallet?.generatedWalletsInfo.map { return $0 } ?? []
    }
    
    public func getImportedWallets() -> [ImportedWallet] {
        return EssentiaStore.shared.currentUser.wallet?.importedWallets.map { return $0 } ?? []
    }
    
    public func getTokensByWalleets() -> [ViewWalletObject: [TokenWallet]] {
        var tokensByWallets: [ViewWalletObject: [TokenWallet]] = [:]
        let tokens: [TokenWallet] = EssentiaStore.shared.currentUser.wallet?.tokenWallets.map { return $0 } ?? []
        var allWallets: [ViewWalletInterface] = getImportedWallets()
        allWallets.append(contentsOf: getGeneratedWallets())
        let wallets: Set<ViewWalletObject> = Set(allWallets.map { return $0.viewWalletObject })
        for wallet in wallets {
            let tokensByCurrentWallet = tokens.filter({ return $0.address == wallet.address })
            guard !tokensByCurrentWallet.isEmpty else { continue }
            tokensByWallets[wallet] = tokensByCurrentWallet
        }
        return tokensByWallets
    }
    
    public func getTotalBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allViewWallets.forEach { (wallet) in
            currentBalance += wallet.balanceInCurrentCurrency
        }
        return currentBalance
    }
    
    public func getYesterdayTotalBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allViewWallets.forEach { (wallet) in
            currentBalance += wallet.yesterdayBalanceInCurrentCurrency
        }
        return currentBalance
    }
    
    var allViewWallets: [ViewWalletInterface] {
        var wallets: [ViewWalletInterface] = getGeneratedWallets()
        wallets.append(contentsOf: getImportedWallets())
        getTokensByWalleets().values.forEach { (tokenWallets) in
            wallets.append(contentsOf: tokenWallets)
        }
        return wallets
    }
    // MARK: - Duplicate
    var allWallets: [WalletInterface] {
        var wallets: [WalletInterface] = getGeneratedWallets()
        wallets.append(contentsOf: getImportedWallets())
        getTokensByWalleets().values.forEach { (tokenWallets) in
            wallets.append(contentsOf: tokenWallets)
        }
        return wallets
    }
    
    public func getBalanceChangePer24Hours(result: @escaping (Double) -> Void) {
        let yesterdayBalance = self.getYesterdayTotalBalanceInCurrentCurrency()
        let todayBalance = self.getTotalBalanceInCurrentCurrency()
        let balanceChange = self.getBalanceChanging(olderBalance: yesterdayBalance, newestBalance: todayBalance)
        result(balanceChange)
    }
    
    public func getBalanceChanging(olderBalance: Double, newestBalance: Double) -> Double {
        let dif = olderBalance - newestBalance
        guard olderBalance != 0 else { return 0 }
        return dif / olderBalance
    }
}
