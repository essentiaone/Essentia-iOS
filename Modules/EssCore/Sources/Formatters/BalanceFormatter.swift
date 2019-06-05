//
//  BalanceFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/12/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import HDWalletKit
import EssModel

fileprivate enum CurrencySimpolPosition {
    case prefix
    case suffix
}

final public class BalanceFormatter {
    private let balanceFormatter: NumberFormatter
    private var currencySymbol: String
    private var symbolPossition: CurrencySimpolPosition
    
    public convenience init(currency: FiatCurrency) {
        self.init()
        balanceFormatter.maximumFractionDigits = 2
        symbolPossition = .prefix
        currencySymbol = currency.symbol
    }
    
    public convenience init(asset: AssetInterface) {
        self.init()
        currencySymbol = asset.symbol
        symbolPossition = .suffix
        balanceFormatter.minimumFractionDigits = 0
        balanceFormatter.maximumFractionDigits = 6
    }
    
    private init() {
        balanceFormatter = NumberFormatter()
        balanceFormatter.numberStyle = .currency
        balanceFormatter.currencyGroupingSeparator = ","
        balanceFormatter.currencySymbol = ""
        balanceFormatter.usesGroupingSeparator = true
        symbolPossition = .prefix
        currencySymbol = ""
        balanceFormatter.decimalSeparator = "."
    }
    
    public func formattedAmmountWithCurrency(amount: Double?) -> String {
        let formatted = formattedAmmount(amount: amount)
        switch symbolPossition {
        case .prefix:
            return currencySymbol + formatted
        case .suffix:
            return formatted + " " + currencySymbol.uppercased()
        }
    }
    
    public func formattedAmmountWithCurrency(amount: String) -> String {
        return formattedAmmountWithCurrency(amount: Double(amount))
    }
    
    public func formattedAmmount(amount: Double?) -> String {
        let amount = amount ?? 0
        return balanceFormatter.string(for: amount) ?? "0"
    }
    
    public func formattedAmmount(amount: String) -> String {
        return formattedAmmount(amount: Double(amount))
    }
}
