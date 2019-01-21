//
//  EssentiaStore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

public func storeCurrentUser() {
//    let user = EssentiaStore.shared.currentUser
//    (inject() as UserStorageServiceInterface).store(user: user)
}

public class EssentiaStore: NSObject {
    public static var shared: EssentiaStore = EssentiaStore()
    public var currentUser: User = User.notSigned
    public var ranks: AssetRank = AssetRank()
    public var currentCredentials: CurrentCredentials = .none
    
    public func setUser(_ user: User, password: String) throws {
//        (inject() as LoggerServiceInterface).log("User: \(user.dislayName) did set", level: .warning)
        currentUser = user
        if user != .notSigned {
            try createCredentials(to: user, with: password)
        }
//        (inject() as UserStorageServiceInterface).store(user: user)
//        (inject() as CurrencyRankDaemonInterface).update()
    }
    
    public func createCredentials(to user: User, with password: String) throws {
        guard let seed = user.seed(withPassword: password) else {
            throw EssentiaError.wrongPassword
        }
        let mnemonic = user.mnemonic(withPassword: password)
        currentCredentials = CurrentCredentials(seed: seed, mnemonic: mnemonic)
    }
}
