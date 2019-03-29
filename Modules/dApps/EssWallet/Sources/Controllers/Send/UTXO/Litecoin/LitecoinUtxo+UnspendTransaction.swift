//
//  LitecoinUtxo+UnspendTransaction.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 3/29/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaBridgesApi
import HDWalletKit

extension LitecoinUTXO {
    
    var unspendTx: UnspentTransaction {
        let lockingScript: Data = Data(hex: scriptPubKey)
        let txidData: Data = Data(hex: String(txid))
        let txHash: Data = Data(txidData.reversed())
        let output = TransactionOutput(value: UInt64(satoshis), lockingScript: lockingScript)
        let outpoint = TransactionOutPoint(hash: txHash, index: UInt32(vout))
        return UnspentTransaction(output: output, outpoint: outpoint)
    }
}
