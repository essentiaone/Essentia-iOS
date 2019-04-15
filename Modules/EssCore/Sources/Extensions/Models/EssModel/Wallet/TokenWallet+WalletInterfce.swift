//
//  TokenWallet+WalletInterfce.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel
import EssDI

extension TokenWallet: WalletInterface, ViewWalletInterface {
    public convenience init(token: Token, wallet: ViewWalletInterface, lastBalance: Double) {
        self.init(name: token.name, token: token, privateKey: wallet.privateKey, address: wallet.address, lastBalance: lastBalance)
    }
    
    public var symbol: String {
        return token?.symbol ?? ""
    }
    
    public var asset: AssetInterface {
        return token ?? Token()
    }
}
