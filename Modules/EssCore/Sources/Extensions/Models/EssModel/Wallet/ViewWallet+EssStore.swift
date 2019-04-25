//
//  ViewWallet+EssStore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 1/9/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssDI

public extension ViewWalletInterface {
    var formattedBalanceInCurrentCurrencyWithSymbol: String {
        guard let currency = EssentiaStore.shared.currentUser.profile?.currency,
              let rank = EssentiaStore.shared.ranks.getRank(for: asset, on: currency) else {
            return "0.0"
        }
        return formattedBalanceInCurrency(currency: currency, with: rank)
    }
    
    var balanceInCurrentCurrency: Double {
        guard let currency = EssentiaStore.shared.currentUser.profile?.currency,
              let rank = EssentiaStore.shared.ranks.getRank(for: asset, on: currency) else {
            return 0
        }
        return balanceInCurrency(currency: currency, with: rank)
    }
    
    var yesterdayBalanceInCurrentCurrency: Double {
        guard let currency = EssentiaStore.shared.currentUser.profile?.currency,
              let rank = EssentiaStore.shared.ranks.getYesterdayRank(for: asset, on: currency) else {
            return 0
        }
        return balanceInCurrency(currency: currency, with: rank)
    }
}
