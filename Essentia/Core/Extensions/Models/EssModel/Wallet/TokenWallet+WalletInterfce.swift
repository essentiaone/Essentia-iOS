//
//  TokenWallet+WalletInterfce.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel
import EssCore

extension TokenWallet: WalletInterface, ViewWalletInterface {
    public convenience init(token: Token, wallet: GeneratingWalletInfo, lastBalance: Double? = nil) {
        self.init(name: token.name, token: token, wallet: wallet, lastBalance: lastBalance)
    }
    
    public var iconUrl: URL {
        return token.iconUrl
    }
    
    public var symbol: String {
        return token.symbol
    }
    
    public var asset: AssetInterface {
        return token
    }
    
    public func address(withSeed: String) -> String {
        return wallet.address(withSeed: withSeed)
    }
    
    public func privateKey(withSeed: String) -> String? {
        let walletService: WalletServiceInterface = inject()
        return walletService.generatePk(wallet, seed: Data(hex: withSeed))
    }
}