//
//  ImportedWallet.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import EssModel
import CryptoSwift

extension ImportedWallet: WalletInterface, ViewWalletInterface {
    public var symbol: String {
        return coin.symbol
    }
    
    public var asset: AssetInterface {
        return coin
    }
    
    public func privateKey(withSeed: String) -> String? {
        return pk
    }
    
    public func address(withSeed: String) -> String {
        return address
    }
}
