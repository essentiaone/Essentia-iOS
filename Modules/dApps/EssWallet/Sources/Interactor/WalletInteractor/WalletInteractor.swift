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

public class WalletInteractor: WalletInteractorInterface {    
    private lazy var walletService: WalletServiceInterface = inject()
    private lazy var tokenService: TokensServiceInterface = inject()
    
    public init() {}
    
    public func isValidWallet(_ wallet: ImportedWallet) -> Bool {
        guard let importdAssets = EssentiaStore.shared.currentUser.wallet?.importedWallets else {
            return true
        }
        let alreadyContainWallet = importdAssets.contains {
            return $0.name == wallet.name || $0.pk == wallet.pk
        }
        return !alreadyContainWallet
    }
    
    public func getCoinsList() -> [Coin] {
        return [Coin.ethereum]
    }
    
    public func getTokensList(result: @escaping ([AssetInterface]) -> Void) {
        tokenService.getTokensList { (tokens) in
            result(tokens)
        }
    }
    
    public func addCoinsToWallet(_ assets: [AssetInterface], wallet: @escaping (GeneratingWalletInfo) -> Void) {
        guard let coins = assets as? [Coin],
            let currentlyAddedWallets = EssentiaStore.shared.currentUser.wallet?.generatedWalletsInfo else { return }
        coins.forEach { coin in
            let currentCoinAssets = currentlyAddedWallets.filter({ return $0.coin == coin })
            let nextDerivationIndex = currentCoinAssets.count
            let walletInfo = GeneratingWalletInfo(name: coin.localizedName,
                                                  coin: coin,
                                                  derivationIndex: Int32(nextDerivationIndex))
            (inject() as UserStorageServiceInterface).update({ _ in
                let seed = EssentiaStore.shared.currentUser.seed
                let address = walletInfo.address(withSeed: seed)
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
    
    public func addTokensToWallet(_ assets: [AssetInterface], for wallet: GeneratingWalletInfo) {
        guard let tokens = assets as? [Token] else { return }
        tokens.forEach { token in
            let tokenAsset = TokenWallet(token: token, wallet: wallet, lastBalance: 0)
            (inject() as UserStorageServiceInterface).update({ (user) in
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
    
    public func getTokensByWalleets() -> [GeneratingWalletInfo: [TokenWallet]] {
        var tokensByWallets: [GeneratingWalletInfo: [TokenWallet]] = [:]
        let tokens: [TokenWallet] = EssentiaStore.shared.currentUser.wallet?.tokenWallets.map { return $0 } ?? []
        guard let wallets = EssentiaStore.shared.currentUser.wallet?.generatedWalletsInfo else { return [:] }
        for wallet in wallets {
            let tokensByCurrentWallet = tokens.filter({ return $0.wallet == wallet })
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
