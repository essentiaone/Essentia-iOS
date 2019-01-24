//
//  CurrencyRankDaemon.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssDI

public class CurrencyRankDaemon: CurrencyRankDaemonInterface {
    var assets: [AssetInterface] = []
    private lazy var  converterService: CurrencyConverterServiceInterface = inject()
    
    public init() {
        update()
    }
    
    public func update() {
        updateRanks()
    }
    
    public func update(callBack: @escaping () -> Void) {
        updateRanks(callBack: callBack)
    }
    
    private func updateRanks(callBack: (() -> Void)? = nil) {
        global {
            self.assets = EssentiaStore.shared.currentUser.wallet.uniqueAssets
            let currency = EssentiaStore.shared.currentUser.profile.currency
            let group = DispatchGroup()
            group.notify(queue: .main, execute: {
                callBack?()
            })
            self.assets.forEach { asset in
                group.enter()
                group.enter()
                self.converterService.getCoinInfo(from: asset, to: currency, info: { (info) in
                    let yesterdayPrice = info.currentPrice + info.priceChange24h
                    EssentiaStore.shared.ranks.setRank(for: currency, and: asset, rank: info.currentPrice, yesterdayPrice: yesterdayPrice)
                    group.leave()
                })
            }
        }
    }
}
