//
//  WalletServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol WalletServiceInterface {
    func generateAddress(_ walletInfo: GeneratingWalletInfo) -> String
    func generateAddress(from pk: String, coin: Coin) -> String
    func generatePk(_ walletInfo: GeneratingWalletInfo) -> String
}
