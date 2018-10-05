//
//  AssetRank.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct AssetRank {
    var ranks: [AssetPrice] = []
    
    func getRank(for currency: Currency, and asset: AssetInterface) -> Double? {
        return ranks.first(where: { $0.currency == currency && $0.asset.name == asset.name})?.price
    }
    
    mutating func setRank(for currency: Currency, and asset: AssetInterface, rank: Double) {
        let assetPrice = AssetPrice(currency: currency, asset: asset, price: rank)
        guard let indexIfExiset = ranks.firstIndex(where: { $0.currency == currency && $0.asset.name == asset.name}) else {
            ranks.append(assetPrice)
            return
        }
        ranks[indexIfExiset] = assetPrice
    }
}
