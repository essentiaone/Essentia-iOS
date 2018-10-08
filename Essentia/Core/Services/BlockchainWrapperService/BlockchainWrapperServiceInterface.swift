//
//  BlockchainWrapperServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol BlockchainWrapperServiceInterface {
    func getBalance(for coin: Coin, address: String, balance: @escaping (Double) -> Void)
    func getBalance(for token: Token, address: String, balance: @escaping (Double) -> Void)
}
