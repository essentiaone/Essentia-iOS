//
//  ViewWalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol ViewWalletInterface {
    var asset: AssetInterface { get }
    var address: String { get }
    var name: String { get }
    var iconUrl: URL { get }
    var symbol: String { get }
    var balanceInCurrentCurrency: String { get }
    var balance: String { get }
    var lastBalance: Double? { get }
}

extension ViewWalletInterface {
    var balanceInCurrentCurrency: String {
        guard let currentBalance = lastBalance,
              let rank = EssentiaStore.ranks.getRank(for: asset) else { return "" }
        let convertedBalance = currentBalance * rank
        return "\(convertedBalance) " + EssentiaStore.currentUser.profile.currency.symbol
    }
}
