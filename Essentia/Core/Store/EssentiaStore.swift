//
//  EssentiaStore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct EssentiaStore {
    static var currentUser: User = User.notSigned
    static var ranks: AssetRank = AssetRank()
    
    static func setUser(_ user: User) {
        currentUser = user
        guard user != .notSigned else { return }
        (inject() as UserStorageServiceInterface).store(user: user)
        (inject() as CurrencyRankDaemonInterface).update()
    }
}
