//
//  BitcoinTransaction+Status.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/26/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import EssentiaBridgesApi

extension BitcoinTransactionValue {
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
            let input = vin.first { $0.addr == address }
            return input?.value
        case .recive:
            let output = vout.first { out in
                return out.scriptPubKey.addresses.contains(where: { $0 == address })
            }
            return Double(output?.value ?? "0")
        default: return 0
        }
    }
}
