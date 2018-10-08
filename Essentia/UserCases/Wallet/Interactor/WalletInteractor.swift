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
    
    func addCoinsToWallet(_ assets: [AssetInterface]) {
        guard let coins = assets as? [Coin] else { return }
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
        (inject() as CurrencyRankDemonInterface).update()
    }
    
    func addTokensToWallet(_ assets: [AssetInterface]) {
        guard let tokens = assets as? [Token] else { return }
        let wallets = EssentiaStore.currentUser.wallet.generatedWalletsInfo
        guard let etherWallet = wallets.first(where: { (wallet) -> Bool in
            return wallet.coin == Coin.ethereum
        }) else { return }
        tokens.forEach { token in
            let tokenAsset = TokenWallet(token: token, wallet: etherWallet)
            EssentiaStore.currentUser.wallet.tokenWallets.append(tokenAsset)
            (inject() as CurrencyRankDemonInterface).update()
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
}
