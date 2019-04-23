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
    public var status: TransactionStatus {
        if isError == "1" {
            return .failure
        }
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }
    
    public func type(for: Address) -> TransactionType {
        switch `for`.uppercased() {
        case to.uppercased():
            return .send
        case from.uppercased():
            return .recive
        default:
            return .recive
        }
    }
}

public extension EthereumTokenTransactionDetail {
    public var status: TransactionStatus {
        if (Int(confirmations) ?? 0) < 5 {
            return .pending
        }
        return .success
    }
    
    public func type(for: Address) -> TransactionType {
        switch `for`.uppercased() {
        case to.uppercased():
            return .send
        case from.uppercased():
            return .recive
        default:
            return .send
        }
    }
}
