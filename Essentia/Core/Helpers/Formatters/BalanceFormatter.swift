//
//  BalanceFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/12/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import HDWalletKit

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
        balanceFormatter.minimumSignificantDigits = 1
    }
    
    convenience init(asset: AssetInterface) {
        self.init()
        balanceFormatter.currencySymbol = ""
        currencySymbol = asset.symbol
        balanceFormatter.minimumSignificantDigits = 6
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
        let formatted = balanceFormatter.string(for: amount) ?? "0"
        guard let currency = currencySymbol else {
            return formatted
        }
        return formatted + " " + currency
    }
    
    func attributed(amount: Double?) -> NSAttributedString {
        let formattedAmmount = self.formattedAmmount(amount: amount)
        let separeted = formattedAmmount.split(separator: " ")
        guard separeted.count == 2 else { return NSAttributedString() }
        let attributed = NSMutableAttributedString(string: String(separeted[0]),
                                                   attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(15)])
        attributed.append(NSAttributedString(string: " "))
        attributed.append(NSAttributedString(string: String(separeted[1]),
                                             attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(15)]))
        return attributed
    }
    
    func attributedHex(amount: String) -> NSAttributedString {
        guard let wei = BInt(amount, radix: 10),
              let etherAmmount = try? WeiEthterConverter.toEther(wei: wei) else {
            return NSAttributedString()
        }
        return attributed(amount: (etherAmmount as NSDecimalNumber).doubleValue)
    }
}
