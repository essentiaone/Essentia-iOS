//
//  CryptoFormatter.swift
//  EssCore
//
//  Created by Pavlo Boiko on 5/30/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import EssentiaNetworkCore
import EssentiaBridgesApi
import HDWalletKit
import EssModel
import EssResources

public class CryptoFormatter {
    public static func formattedAmmount(amount: Double?, type: TransactionType, asset: AssetInterface) -> NSAttributedString {
        let ammountFormatter = BalanceFormatter(asset: asset)
        let formattedAmmount = ammountFormatter.formattedAmmountWithCurrency(amount: amount)
        let separeted = formattedAmmount.split(separator: " ")
        guard separeted.count == 2 else { return NSAttributedString() }
        let attributed = NSMutableAttributedString(string: String(separeted[0]),
                                                   attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(15)])
        attributed.append(NSAttributedString(string: " "))
        attributed.append(NSAttributedString(string: String(separeted[1]),
                                             attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(15)]))
        switch type {
        case .recive:
            attributed.addAttributes([NSAttributedString.Key.foregroundColor: RGB(59, 207, 85)], range: NSRange(location: 0, length: attributed.length))
        default: break
        }
        return attributed
    }
    
    public static func attributedHex(amount: String, type: TransactionType, asset: AssetInterface) -> NSAttributedString {
        guard let wei = BInt(amount, radix: 10),
            let etherAmmount = try? WeiEthterConverter.toEther(wei: wei) else {
                return NSAttributedString()
        }
        return formattedAmmount(amount: (etherAmmount as NSDecimalNumber).doubleValue, type: type, asset: asset)
    }
    
    public static func attributedHex(amount: String, type: TransactionType, decimals: Int, asset: AssetInterface) -> NSAttributedString {
        guard let convertedAmmount = try? WeiEthterConverter.toToken(balance: amount, decimals: decimals, radix: 10) else {
            return NSAttributedString()
        }
        return formattedAmmount(amount: (convertedAmmount as NSDecimalNumber).doubleValue, type: type, asset: asset)
    }
}
