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

public struct ViewWalletObject: Hashable {
    public static func == (lhs: ViewWalletObject, rhs: ViewWalletObject) -> Bool {
        return lhs.address == rhs.address && lhs.name == rhs.name
    }
    
    public var address: String
    public var name: String
}

extension ViewWalletInterface {
    public var viewWalletObject: ViewWalletObject {
        return ViewWalletObject(address: address, name: name)
    }
}
