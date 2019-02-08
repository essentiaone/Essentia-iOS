//
//  ViewWalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

public protocol ViewWalletInterface: WalletInterface, ThreadConfined {
    var iconUrl: URL { get }
    var symbol: String { get }
    func balanceInCurrency(currency: FiatCurrency, with rank: Double) -> Double
    func yesterdayBalanceCurrency(currency: FiatCurrency, with rank: Double) -> Double
    func formattedBalanceInCurrency(currency: FiatCurrency, with rank: Double) -> String
    var formattedBalance: String { get }
    var lastBalance: Double { get }
}

public func == (lhs: ViewWalletInterface, rhs: ViewWalletInterface) -> Bool {
    return lhs.asset.name == rhs.asset.name && lhs.asset.type == rhs.asset.type
}
