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
        assets = EssentiaStore.currentUser.wallet.uniqueAssets
        let currency = EssentiaStore.currentUser.profile.currency
        assets.forEach { asset in
            converterService.getCoinInfo(from: asset, to: currency, info: { (info) in
                let yesterdayPrice = info.currentPrice + info.priceChange24h
                EssentiaStore.ranks.setRank(for: currency, and: asset, rank: info.currentPrice, yesterdayPrice: yesterdayPrice)
            })
        }
    }
}
