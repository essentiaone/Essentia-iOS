//
//  CurrencyRankDaemon.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class CurrencyRankDaemon: CurrencyRankDaemonInterface {
    var assets: [AssetInterface] = []
    private lazy var  converterService: CurrencyConverterServiceInterface = inject()
    
    init() {
        update()
    }
    
    func update() {
        updateRanks()
    }
    
    func update(callBack: @escaping () -> Void) {
        updateRanks(callBack: callBack)
    }
    
    private func updateRanks(callBack: (() -> Void)? = nil) {
        global {
            self.assets = EssentiaStore.currentUser.wallet.uniqueAssets
            let currency = EssentiaStore.currentUser.profile.currency
            self.assets.forEach { asset in
                self.converterService.getCoinInfo(from: asset, to: currency, info: { (info) in
                    let yesterdayPrice = info.currentPrice + info.priceChange24h
                    EssentiaStore.ranks.setRank(for: currency, and: asset, rank: info.currentPrice, yesterdayPrice: yesterdayPrice)
                    main {
                        callBack?()
                    }
                })
            }
        }
    }
}
