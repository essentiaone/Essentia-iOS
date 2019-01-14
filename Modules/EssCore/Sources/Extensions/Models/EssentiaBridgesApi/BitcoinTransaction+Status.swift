//
//  BitcoinTransaction+Status.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/26/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import EssentiaBridgesApi
import EssModel

public extension BitcoinTransactionValue {
    public var status: TransactionStatus {
        if confirmations >= 5 {
            return .success
        }
        return .pending
    }
    
    public func type(for address: String) -> TransactionType {
        let input = vin.contains {
            return $0.addr == address
        }
        if input {
            return .send
        }
        return .recive
    }
    
    public func transactionAmmount(for address: String) -> Double? {
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
