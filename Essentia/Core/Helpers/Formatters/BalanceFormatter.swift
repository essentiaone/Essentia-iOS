//
//  BalanceFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/12/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

final class BalanceFormatter {
    private let balanceFormatter: NumberFormatter
    private var currencySymbol: String?
    
    convenience init(currency: Currency) {
        self.init()
        balanceFormatter.currencySymbol = currency.symbol
    }
    
    convenience init(asset: AssetInterface) {
        self.init()
        balanceFormatter.currencySymbol = ""
        currencySymbol = asset.symbol
    }
    
    private init() {
        balanceFormatter = NumberFormatter()
        balanceFormatter.numberStyle = .currency
        balanceFormatter.currencyGroupingSeparator = ","
        balanceFormatter.usesGroupingSeparator = true
        balanceFormatter.decimalSeparator = "."
    }
    
    func formattedAmmount(amount: Double?) -> String {
        let amount = amount ?? 0
        let formatted = balanceFormatter.string(for: amount) ?? ""
        guard let currency = currencySymbol else {
            return formatted
        }
        return formatted + " " + currency
    }
}
