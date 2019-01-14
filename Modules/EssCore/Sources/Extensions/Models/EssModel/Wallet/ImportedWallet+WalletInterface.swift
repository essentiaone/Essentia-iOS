//
//  ImportedWallet.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import EssModel
import CryptoSwift

fileprivate var iv = "457373656e746961"

extension ImportedWallet: WalletInterface, ViewWalletInterface {
    public convenience init?(address: String, coin: Coin, pk: String, name: String, lastBalance: Double? = nil, seed: String) {
        guard let aesInstance = ImportedWallet.aesInstance(withSeed: seed),
            let encodedBytes = try? aesInstance.encrypt(pk.bytes)  else { return nil }
        self.init(address: address, coin: coin, encodedPk: Data(bytes: encodedBytes), name: name, lastBalance: lastBalance)
    }
    
    public var symbol: String {
        return coin.symbol
    }
    
    public var asset: AssetInterface {
        return coin
    }
    
    public func privateKey(withSeed: String) -> String? {
        guard let aesInstance = ImportedWallet.aesInstance(withSeed: withSeed),
            let decrypted = try? aesInstance.decrypt(encodedPk.bytes) else { return nil }
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    private static func aesInstance(withSeed: String) -> AES? {
        let key = withSeed.sha256().md5()
        return try? AES(key: key, iv: iv)
    }
}
