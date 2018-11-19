//
//  ViewWalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol ViewWalletInterface: WalletInterface {
    var iconUrl: URL { get }
    var symbol: String { get }
    var balanceInCurrentCurrency: Double { get }
    var yesterdayBalanceInCurrentCurrency: Double { get }
    var formattedBalanceInCurrentCurrency: String { get }
    var formattedBalanceInCurrentCurrencyWithSymbol: String { get }
    var formattedBalanceWithSymbol: String { get }
    var formattedBalance: String { get }
    var lastBalance: Double? { get }
    func privateKey(withSeed: String) -> String
}

func == (lhs: ViewWalletInterface, rhs: ViewWalletInterface) -> Bool {
    return lhs.asset.name == rhs.asset.name && lhs.asset.type == rhs.asset.type && lhs.address == rhs.address
}

extension ViewWalletInterface {
    var balanceInCurrentCurrency: Double {
        guard let currentBalance = lastBalance,
              let rank = EssentiaStore.shared.ranks.getRank(for: asset) else { return 0 }
        return currentBalance * rank
    }
    
    var yesterdayBalanceInCurrentCurrency: Double {
        guard let currentBalance = lastBalance,
            let rank = EssentiaStore.shared.ranks.getYesterdayRank(for: asset) else { return 0 }
        return currentBalance * rank
    }
    
    var formattedBalanceInCurrentCurrencyWithSymbol: String {
        let formatter = BalanceFormatter(currency: EssentiaStore.shared.currentUser.profile.currency)
        return  formatter.formattedAmmountWithCurrency(amount: balanceInCurrentCurrency)
    }
    
    var formattedBalanceInCurrentCurrency: String {
        let formatter = BalanceFormatter(currency: EssentiaStore.shared.currentUser.profile.currency)
        return formatter.formattedAmmount(amount: balanceInCurrentCurrency)
    }
    
    var formattedBalance: String {
        let formatter = BalanceFormatter(asset: asset)
        return formatter.formattedAmmount(amount: lastBalance)
    }
    
    var iconUrl: URL {
        return CoinIconsUrlFormatter(name: asset.name, size: .x128).url
    }
    
    var formattedBalanceWithSymbol: String {
        return formattedBalance + " " + asset.symbol
    }
}
