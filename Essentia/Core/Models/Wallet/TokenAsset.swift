//
//  TokenWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct TokenAsset: Codable {
    var token: Token
    var wallet: GeneratingWalletInfo
}
