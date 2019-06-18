//
//  CoinWalletInterface.swift
//  EssModel
//
//  Created by Pavlo Boiko on 6/19/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public protocol CoinWalletInterface: ViewWalletInterface {
    var coin: Coin { get }
}
