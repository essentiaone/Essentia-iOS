//
//  TransactionStatus+Assets.swift
//  Essentia
//
//  Created by Pavlo Boiko on 1/10/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssCore
import EssResources

extension TransactionStatus {
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
