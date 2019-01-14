//
//  ViewWalletInterface+Default.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel
import EssCore

public extension ViewWalletInterface {
    public func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double {
        guard let currentBalance = lastBalance else { return 0 }
        return currentBalance * rank
    }
    
    public func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double {
        guard let currentBalance = lastBalance else { return 0 }
        return currentBalance * rank
    }
    
    public func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String {
        let formatter = BalanceFormatter(currency: currency)
        return  formatter.formattedAmmountWithCurrency(amount: balanceInCurrency(currency: currency, with: rank))
    }
    
    public var formattedBalance: String {
        let formatter = BalanceFormatter(asset: asset)
        return formatter.formattedAmmount(amount: lastBalance)
    }
    
    public var iconUrl: URL {
        return CoinIconsUrlFormatter(name: asset.name, size: .x128).url
    }
    
    public var formattedBalanceWithSymbol: String {
        return formattedBalance + " " + asset.symbol
    }
}
