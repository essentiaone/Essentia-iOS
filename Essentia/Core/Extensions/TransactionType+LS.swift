//
//  TransactionType+LS.swift
//  Essentia
//
//  Created by Pavlo Boiko on 1/10/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssCore

extension TransactionType {
    var title: String {
        return LS("Wallet.TransactionType." + rawValue )
    }
}
