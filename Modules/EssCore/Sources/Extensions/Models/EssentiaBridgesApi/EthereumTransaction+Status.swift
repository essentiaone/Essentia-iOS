//
//  EthereumTransaction+Status.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/26/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import EssentiaBridgesApi
import EssModel

public extension EthereumTransactionDetail {
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
        switch `for`.uppercased() {
        case to.uppercased():
            return .recive
        case from.uppercased():
            return .send
        default:
            return .recive
        }
    }
}

public extension EthereumTokenTransactionDetail {
    var status: TransactionStatus {
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }
    
    func type(for: Address) -> TransactionType {
        switch `for`.uppercased() {
        case to.uppercased():
            return .recive
        case from.uppercased():
            return .send
        default:
            return .send
        }
    }
}
