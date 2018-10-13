//
//  WalletInteractor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import PromiseKit

class WalletInteractor: WalletInteractorInterface {    
    private lazy var walletService: WalletServiceInterface = inject()
    private lazy var tokenService: TokensServiceInterface = inject()
    private lazy var blockchainWrapper: BlockchainWrapperServiceInterface = inject()
    
    func isValidWallet(_ wallet: ImportedWallet) -> Bool {
        let importdAssets = EssentiaStore.currentUser.wallet.importedWallets
        let alreadyContainWallet = importdAssets.contains {
            return $0.name == wallet.name || $0.pk == wallet.pk
        }
        return !alreadyContainWallet
    }
    
    func getCoinsList() -> [AssetInterface] {
        return Coin.allCases
    }
    
    func getTokensList(result: @escaping ([AssetInterface]) -> Void) {
        tokenService.getTokensList { (tokens) in
            result(tokens)
        }
    }
    
    @discardableResult func addCoinsToWallet(_ assets: [AssetInterface]) -> [GeneratingWalletInfo] {
        guard let coins = assets as? [Coin] else { return [] }
        var currentlyAddedWallets = EssentiaStore.currentUser.wallet.generatedWalletsInfo
        coins.forEach { coin in
            let currentCoinAssets = currentlyAddedWallets.filter({ return $0.coin == coin })
            let nextDerivationIndex = currentCoinAssets.count
            let walletInfo = GeneratingWalletInfo(name: coin.name,
                                                  coin: coin,
                                                  derivationIndex: UInt32(nextDerivationIndex))
            currentlyAddedWallets.append(walletInfo)
        }
        EssentiaStore.currentUser.wallet.generatedWalletsInfo = currentlyAddedWallets
        (inject() as CurrencyRankDaemonInterface).update()
        return currentlyAddedWallets
    }
    
    func addTokensToWallet(_ assets: [AssetInterface]) {
        guard let wallet = addCoinsToWallet([Coin.ethereum]).first else { return }
        addTokensToWallet(assets, for: wallet)
    }
    
    func addTokensToWallet(_ assets: [AssetInterface], for wallet: GeneratingWalletInfo) {
        guard let tokens = assets as? [Token] else { return }
        tokens.forEach { token in
            let tokenAsset = TokenWallet(token: token, wallet: wallet)
            EssentiaStore.currentUser.wallet.tokenWallets.append(tokenAsset)
            (inject() as CurrencyRankDaemonInterface).update()
        }
    }
    
    func getGeneratedWallets() -> [GeneratedWallet] {
        let walletsInfo = EssentiaStore.currentUser.wallet.generatedWalletsInfo
        let seed = Data(hex: EssentiaStore.currentUser.seed)
        return walletsInfo.map({ return walletService.generateWallet(seed: seed, walletInfo: $0) })
    }
    
    func getImportedWallets() -> [ImportedWallet] {
        return EssentiaStore.currentUser.wallet.importedWallets
    }
    
    func getTokensByWalleets() -> [GeneratingWalletInfo : [TokenWallet]] {
        var tokensByWallets: [GeneratingWalletInfo : [TokenWallet]] = [:]
        let tokens = EssentiaStore.currentUser.wallet.tokenWallets
        let wallets = EssentiaStore.currentUser.wallet.generatedWalletsInfo
        for wallet in wallets {
            let tokensByCurrentWallet = tokens.filter({ return $0.wallet == wallet })
            guard !tokensByCurrentWallet.isEmpty else { continue }
            tokensByWallets[wallet] = tokensByCurrentWallet
        }
        return tokensByWallets
    }
    
    func getBalance(for wallet: WalletInterface, balance: @escaping (Double) -> Void) {
        blockchainWrapper.getBalance(for: wallet.coin, address: wallet.address, balance: balance)
    }
    
    func getBalance(for token: TokenWallet, balance: @escaping (Double) -> Void) {
        blockchainWrapper.getBalance(for: token.token, address: token.address, balance: balance)
    }
    
    func getBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allWallets.forEach { (wallet) in
            currentBalance += wallet.balanceInCurrentCurrency
        }
        return currentBalance
    }
    
    func getYesterdayBalanceInCurrentCurrency() -> Double {
        var currentBalance: Double = 0
        allWallets.forEach { (wallet) in
            currentBalance += wallet.yesterdayBalanceInCurrentCurrency
        }
        return currentBalance
    }
    
    var allWallets: [ViewWalletInterface] {
        var wallets: [ViewWalletInterface] = getGeneratedWallets()
        wallets.append(contentsOf: getImportedWallets())
        getTokensByWalleets().values.forEach { (tokenWallets) in
            wallets.append(contentsOf: tokenWallets)
        }
        return wallets
    }
    
    func getBalanceChangePer24Hours() -> Double {
        let yesterdayBalance = getYesterdayBalanceInCurrentCurrency()
        let dif = getBalanceInCurrentCurrency() - yesterdayBalance
        guard yesterdayBalance != 0 else { return 0 }
        return (dif / yesterdayBalance)
    }
}
