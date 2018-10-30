//
//  TransactionStatus.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum TransactionStatus {
    case success
    case failure
    case pending
    
    func iconForTxType(_ type: TransactionType) -> UIImage {
        let imageProvider: AppImageProviderInterface = inject()
        switch (type, self) {
        case (_, .failure):
            return imageProvider.txStatusFailure
        case (_, .pending):
            return imageProvider.txStatusPending
        case (.send, _):
            return imageProvider.txStatusSend
        case (.recive, _):
            return imageProvider.txStatusRecived
        case (.exchange, _):
            return imageProvider.txStatusExchang
        }
    }
}
