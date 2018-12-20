//
//  EssentiaStore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class EssentiaStore: NSObject {
    static var shared: EssentiaStore = EssentiaStore()
    
    var currentUser: User = User.notSigned
    var ranks: AssetRank = AssetRank()
    var currentCredentials: CurrentCredentials = .none
    
    func setUser(_ user: User) {
        (inject() as LoggerServiceInterface).log("User: \(user.dislayName) did set", level: .warning)
        currentUser = user
        (inject() as UserStorageServiceInterface).store(user: user)
        (inject() as CurrencyRankDaemonInterface).update()
    }
}
