//
//  AssetRank.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public struct AssetRank {
    public var ranks: [AssetPrice] = []
    
    public init(ranks: [AssetPrice]) {
        self.ranks = ranks
    }
    
    public init() {}
    
    public func getRank(for asset: AssetInterface, on currency: FiatCurrency) -> Double? {
        return getRank(for: currency, and: asset)?.price
    }
    
    public func getYesterdayRank(for asset: AssetInterface, on currency: FiatCurrency) -> Double? {
       return getRank(for: currency, and: asset)?.yesterdayPrice
    }
    
    public mutating func setRank(for currency: FiatCurrency, and asset: AssetInterface, rank: Double, yesterdayPrice: Double) {
        let assetPrice = AssetPrice(currency: currency, asset: asset, price: rank, yesterdayPrice: yesterdayPrice)
        guard let indexIfExiset = ranks.firstIndex(where: { $0.currency == currency && $0.asset.name == asset.name}) else {
            ranks.append(assetPrice)
            return
        }
        ranks[indexIfExiset] = assetPrice
    }
    
    private func getRank(for currency: FiatCurrency, and asset: AssetInterface) -> AssetPrice? {
        return ranks.first(where: { $0.currency == currency && $0.asset.name == asset.name})
    }
}
