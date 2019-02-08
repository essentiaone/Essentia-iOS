//
//  EssentiaStore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssDI

public class EssentiaStore: NSObject {
    public static var shared: EssentiaStore = EssentiaStore()
    
    public var currentUser: User = User.notSigned
    public var ranks: AssetRank = AssetRank()
    public var currentLangugale: LocalizationLanguage = .english
    
    public func setUser(_ user: User) {
        (inject() as LoggerServiceInterface).log("User: \(user.seed) did set", level: .warning)
        currentUser = user
        currentLangugale = currentUser.profile?.language ?? .english
        (inject() as CurrencyRankDaemonInterface).update()
    }
}
