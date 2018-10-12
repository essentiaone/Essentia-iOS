//
//  ViewWalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol ViewWalletInterface: Codable {
    var asset: AssetInterface { get }
    var address: String { get }
    var name: String { get }
    var iconUrl: URL { get }
    var symbol: String { get }
    var balanceInCurrentCurrency: Double { get }
    var yesterdayBalanceInCurrentCurrency: Double { get }
    var formattedBalanceInCurrentCurrency: String { get }
    var formattedBalance: String { get }
    var lastBalance: Double? { get }
    
}

extension ViewWalletInterface {
    var balanceInCurrentCurrency: Double {
        guard let currentBalance = lastBalance,
              let rank = EssentiaStore.ranks.getRank(for: asset) else { return 0 }
        return currentBalance * rank
    }
    
    var yesterdayBalanceInCurrentCurrency: Double {
        guard let currentBalance = lastBalance,
            let rank = EssentiaStore.ranks.getYesterdayRank(for: asset) else { return 0 }
        return currentBalance * rank
    }
    
    var formattedBalanceInCurrentCurrency: String {
       let formatter = BalanceFormatter(currency: EssentiaStore.currentUser.profile.currency)
        return  formatter.formattedAmmount(amount: balanceInCurrentCurrency)
    }
    
    var formattedBalance: String {
        let formatter = BalanceFormatter(asset: asset)
        return formatter.formattedAmmount(amount: lastBalance)
    }
}
