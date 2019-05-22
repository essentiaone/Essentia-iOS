//
//  UtxoTransaction+Status.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/26/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import EssentiaBridgesApi
import EssModel

public extension UtxoTransactionValue {
    var status: TransactionStatus {
        if confirmations >= 2 {
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
            
            let input = vin
                .map { return $0.value ?? 0 }
                .reduce(0.0, +)
            let myOutputs = vout
                .filter { $0.scriptPubKey.addresses?.first == address }
                .map { return $0.value }
                .reduce(0.0, { return $0 + (Double($1) ?? 0) })
            return -(input - myOutputs)
        case .recive:
            let output = vout.first { out in
                return out.scriptPubKey.addresses?.contains(where: { $0 == address }) ?? false
            }
            return Double(output?.value ?? "0")
        default: return 0
        }
    }
}
