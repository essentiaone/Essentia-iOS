//
//  TokenWallet+WalletInterfce.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

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
    
    public var address: String {
        return ""
        //            return (inject() as WalletServiceInterface).generateAddress(wallet)
    }
    
    public func privateKey(withSeed: String) -> String? {
        return ""
        //            let walletService: WalletServiceInterface = inject()
        //            return walletService.generatePk(wallet)
    }
}
