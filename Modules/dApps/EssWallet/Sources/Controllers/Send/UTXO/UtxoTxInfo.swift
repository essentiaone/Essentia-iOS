//
//  UtxoTxInfo.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 3/12/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

struct UtxoTxInfo {
    var address: String
    var ammount: SelectedTransacrionAmmount
    var wallet: ViewWalletInterface
    var feePerByte: UInt64
}
