//
//  TokenWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TokenWallet: Codable, WalletInterface, ViewWalletInterface {
    var name: String
    var token: Token
    var wallet: GeneratingWalletInfo
    var lastBalance: Double?
    
    init(token: Token, wallet: GeneratingWalletInfo, lastBalance: Double? = nil) {
        self.token = token
        self.wallet = wallet
        self.lastBalance = lastBalance
        self.name = token.name
    }
    
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: token.id, size: .x128).url
    }
    
    var symbol: String {
        return token.symbol
    }
    
    var asset: AssetInterface {
        return token
    }
    
    var address: String {
        return (inject() as WalletServiceInterface).generateAddress(wallet)
    }
    
    func privateKey(withSeed: String) -> String {
        let walletService: WalletServiceInterface = inject()
        let seed = EssentiaStore.shared.currentUser.seed
        let data = Data(hex: seed)
        return walletService.generateWallet(seed: data, walletInfo: wallet).pk
    }
}
