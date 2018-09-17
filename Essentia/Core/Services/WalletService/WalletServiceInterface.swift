//
//  WalletServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol WalletServiceInterface {
    func generateWallet(seed: Data, walletInfo: GeneratingWalletInfo) -> GeneratedWallet
}
