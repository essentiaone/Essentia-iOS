//
//  EthereumTransaction+Status.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/26/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import EssentiaBridgesApi

extension EthereumTransactionDetail {
    var status: TransactionStatus {
        if isError == "1" {
            return .failure
        }
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }
    
    func type(for: Address) -> TransactionType {
        switch `for` {
        case to:
            return .recive
        case from:
            return .send
        default:
            return .recive
        }
    }
}
