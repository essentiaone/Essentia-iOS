//
//  ViewWallet+EssStore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 1/9/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssStore

public extension ViewWalletInterface {
    public var formattedBalanceInCurrentCurrencyWithSymbol: String {
        let currency = EssentiaStore.shared.currentUser.profile.currency
        guard let rank = EssentiaStore.shared.ranks.getRank(for: asset, on: currency) else {
            return ""
        }
        return formattedBalanceInCurrency(currency: currency, with: rank)
    }
    
    public var balanceInCurrentCurrency: Double {
        let currency = EssentiaStore.shared.currentUser.profile.currency
        guard let rank = EssentiaStore.shared.ranks.getRank(for: asset, on: currency) else {
            return 0
        }
        return balanceInCurrency(currency: currency, with: rank)
    }
    
    public var yesterdayBalanceInCurrentCurrency: Double {
        let currency = EssentiaStore.shared.currentUser.profile.currency
        guard let rank = EssentiaStore.shared.ranks.getYesterdayRank(for: asset, on: currency) else {
            return 0
        }
        return balanceInCurrency(currency: currency, with: rank)
    }
}
