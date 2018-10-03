//
//  CoinGeckoCurrencyModel.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct CoinGeckoCurrencyModel: Codable {
    var id: String
    var symbol: String
    var name: String
    var image: String
    var currentPrice: Double
    var marketCap: Double
    var marketCapRank: Int
    var totalValue: Double
    var hight24h: Double
    var low24h: Double
    var priceChange24h: Double
    var priceChangePercentage24h: Double
    var circulatingSupply: String
    var ath: Double
    var athChangePercentage: Double
    var athDate: String
    var lastUpdate: String
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image, ath
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case totalValue = "total_volume"
        case hight24h = "high_24h"
        case low24h = "low_24h"
        case priceChange24h = "price_change_24h"
        case priceChangePercentage24h = "price_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case lastUpdate = "last_updated"
    }
}
