//
//  CoinGeckoCurrencyModel.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public struct CoinGeckoCurrencyModel: Codable {
    public var id: String
    public var symbol: String
    public var name: String
    public var image: String
    public var currentPrice: Double
    public var marketCap: Double
    public var marketCapRank: Int
    public var totalValue: Double
    public var hight24h: Double
    public var low24h: Double
    public var priceChange24h: Double
    public var priceChangePercentage24h: Double
    public var circulatingSupply: String
    public var ath: Double
    public var athChangePercentage: Double
    public var athDate: String
    public var lastUpdate: String
    
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
