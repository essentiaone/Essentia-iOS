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
    
    convenience init(currency: Currency) {
        self.init()
        balanceFormatter.locale = Locale(identifier: "en_US")
        balanceFormatter.currencySymbol = currency.symbol
    }
    
    convenience init(asset: AssetInterface) {
        self.init()
        balanceFormatter.locale = Locale(identifier: "de_DE")
        balanceFormatter.currencySymbol = asset.symbol
    }
    
    private init() {
        balanceFormatter = NumberFormatter()
        balanceFormatter.numberStyle = .currency
        balanceFormatter.currencyGroupingSeparator = ","
        balanceFormatter.usesGroupingSeparator = true
        balanceFormatter.decimalSeparator = "."
    }
    
    func attributedAmount(amount: Double?) -> String {
        let amount = amount ?? 0
        return balanceFormatter.string(for: amount) ?? ""
    }
}
