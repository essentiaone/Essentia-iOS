//
//  ImportedWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import HDWalletKit
import CryptoSwift

fileprivate var iv = "457373656e746961"

class ImportedWallet: Codable, WalletInterface, ViewWalletInterface {
    var address: String
    var coin: Coin
    var encodedPk: Data
    var name: String
    var lastBalance: Double?
    
    init?(address: String, coin: Coin, pk: String, name: String, lastBalance: Double? = nil) {
        self.address = address
        self.coin = coin
        let seed = EssentiaStore.shared.currentUser.seed
        guard let aesInstance = ImportedWallet.aesInstance(withSeed: seed),
              let encodedBytes = try? aesInstance.encrypt(pk.bytes)  else { return nil }
        self.encodedPk = Data(bytes: encodedBytes)
        self.name = name
        self.lastBalance = lastBalance
    }
    
    var symbol: String {
        return coin.symbol
    }
    
    var asset: AssetInterface {
        return coin
    }
    
    func privateKey(withSeed: String) -> String? {
        guard let aesInstance = ImportedWallet.aesInstance(withSeed: withSeed),
              let decrypted = try? aesInstance.decrypt(encodedPk.bytes) else { return nil }
        return String(bytes: decrypted, encoding: .utf8)
    }
    
    private static func aesInstance(withSeed: String) -> AES? {
        let key = withSeed.sha256().md5()
        return try? AES(key: key, iv: iv)
    }
}
