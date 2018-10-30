//
//  TransactionType.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum TransactionType: String {
    case send
    case recive
    case exchange
    
    var title: String {
        return LS("Wallet.TransactionType." + rawValue )
    }
}
