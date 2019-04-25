//
//  LitecoinTransaction.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/29/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import EssentiaBridgesApi
import EssModel

public extension LitecoinTransactionValue {
    var status: TransactionStatus {
        if confirmations >= 5 {
            return .success
        }
        return .pending
    }
    
    func type(for address: String) -> TransactionType {
        let input = vin.contains {
            return $0.addr == address
        }
        if input {
            return .send
        }
        return .recive
    }
    
    func transactionAmmount(for address: String) -> Double? {
        switch type(for: address) {
        case .send:
            let input = vin.first { $0.addr == address }?.value ?? 0
            let myOutputs = vout.first { $0.scriptPubKey.addresses.first == address }?.value ?? "0"
            return input - (Double(myOutputs) ?? 0)
        case .recive:
            let output = vout.first { out in
                return out.scriptPubKey.addresses.contains(where: { $0 == address })
            }
            return Double(output?.value ?? "0")
        default: return 0
        }
    }
}
