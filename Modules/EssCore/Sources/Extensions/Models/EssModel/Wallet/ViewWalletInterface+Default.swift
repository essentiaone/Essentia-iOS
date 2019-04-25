//
//  ViewWalletInterface+Default.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

public extension ViewWalletInterface {
    func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double {
        return lastBalance * rank
    }
    
    func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double {
        return lastBalance * rank
    }
    
    func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String {
        let formatter = BalanceFormatter(currency: currency)
        return  formatter.formattedAmmountWithCurrency(amount: balanceInCurrency(currency: currency, with: rank))
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
