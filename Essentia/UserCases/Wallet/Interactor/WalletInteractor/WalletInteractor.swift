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
import EssStore

class WalletInteractor: WalletInteractorInterface {    
    private lazy var walletService: WalletServiceInterface = inject()
    private lazy var tokenService: TokensServiceInterface = inject()
    
    func isValidWallet(_ wallet: ImportedWallet) -> Bool {
        let importdAssets = EssentiaStore.shared.currentUser.wallet.importedWallets
        let alreadyContainWallet = importdAssets.contains {
            return $0.name == wallet.name || $0.encodedPk == wallet.encodedPk
        }
        return !alreadyContainWallet
    }
    
    func getCoinsList() -> [Coin] {
        return [Coin.ethereum]
    }
    
    func getTokensList(result: @escaping ([AssetInterface]) -> Void) {
        tokenService.getTokensList { (tokens) in
            result(tokens)
        }
    }
    
    @discardableResult func addCoinsToWallet(_ assets: [AssetInterface]) -> [GeneratingWalletInfo] {
        guard let coins = assets as? [Coin] else { return [] }
        var currentlyAddedWallets = EssentiaStore.shared.currentUser.wallet.generatedWalletsInfo
        coins.forEach { coin in
            let currentCoinAssets = currentlyAddedWallets.filter({ return $0.coin == coin })
            let nextDerivationIndex = currentCoinAssets.count
            let walletInfo = GeneratingWalletInfo(name: coin.localizedName,
                                                  coin: coin,
                                                  derivationIndex: UInt32(nextDerivationIndex))
            let seed = EssentiaStore.shared.currentCredentials.seed
            let address = walletInfo.address(withSeed: seed)
            let generatedName = walletInfo.name + " " + address.suffix(4)
            walletInfo.name = generatedName
            currentlyAddedWallets.append(walletInfo)
        }
        EssentiaStore.shared.currentUser.wallet.generatedWalletsInfo = currentlyAddedWallets
        (inject() as CurrencyRankDaemonInterface).update()
        return currentlyAddedWallets
    }
    
    func addTokensToWallet(_ assets: [AssetInterface]) {
        let wallet = addCoinsToWallet([EssModel.Coin.ethereum]).first {
            return $0.coin == EssModel.Coin.ethereum
        }
        addTokensToWallet(assets, for: wallet!)
    }
    
    func addTokensToWallet(_ assets: [AssetInterface], for wallet: GeneratingWalletInfo) {
        guard let tokens = assets as? [Token] else { return }
        tokens.forEach { token in
            let tokenAsset = TokenWallet(token: token, wallet: wallet)
            EssentiaStore.shared.currentUser.wallet.tokenWallets.append(tokenAsset)
            storeCurrentUser()
            (inject() as CurrencyRankDaemonInterface).update()
        }
    }
    
    func getGeneratedWallets() -> [GeneratingWalletInfo] {
        return EssentiaStore.shared.currentUser.wallet.generatedWalletsInfo
    }
    
    func getImportedWallets() -> [ImportedWallet] {
        return EssentiaStore.shared.currentUser.wallet.importedWallets
    }
    
    func getTokensByWalleets() -> [GeneratingWalletInfo: [TokenWallet]] {
        var tokensByWallets: [GeneratingWalletInfo: [TokenWallet]] = [:]
        let tokens = EssentiaStore.shared.currentUser.wallet.tokenWallets
        let wallets = EssentiaStore.shared.currentUser.wallet.generatedWalletsInfo
        for wallet in wallets {
            let tokensByCurrentWallet = tokens.filter({ return $0.wallet == wallet })
            guard !tokensByCurrentWallet.isEmpty else { continue }
            tokensByWallets[wallet] = tokensByCurrentWallet
        }
        return tokensByWallets
    }
    
    func getTotalBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allViewWallets.forEach { (wallet) in
            currentBalance += wallet.balanceInCurrentCurrency
        }
        return currentBalance
    }
    
    func getYesterdayTotalBalanceInCurrentCurrency() -> Double {
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
    
    func getBalanceChangePer24Hours(result: @escaping (Double) -> Void) {
        DispatchQueue.global().async {
            let yesterdayBalance = self.getYesterdayTotalBalanceInCurrentCurrency()
            let todayBalance = self.getTotalBalanceInCurrentCurrency()
            let balanceChange = self.getBalanceChanging(olderBalance: yesterdayBalance, newestBalance: todayBalance)
            DispatchQueue.main.async {
                result(balanceChange)
            }
        }
    }
    
    func getBalanceChanging(olderBalance: Double, newestBalance: Double) -> Double {
        let dif = olderBalance - newestBalance
        guard olderBalance != 0 else { return 0 }
        return dif / olderBalance
    }
}
