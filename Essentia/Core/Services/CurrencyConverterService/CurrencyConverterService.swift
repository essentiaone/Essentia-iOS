//
//  CurrencyConverterService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

fileprivate struct Constants {
    static var sourceUrl = "https://api.coingecko.com/api/v3"
}

class CurrencyConverterService: CurrencyConverterServiceInterface {
    let networkManager: NetworkManager
    
    init() {
        networkManager = NetworkManager(Constants.sourceUrl)
    }
    
    func convertBalance(value: Double, from coin: String, to currency: Currency, convertedValue: @escaping (Double) -> Void) {
        let endpoint = CurrencyConverterEndpoint.getPrice(forCoin: coin.formattedCoinName, inCurrency: currency)
        (inject() as LoaderInterface).show()
        networkManager.makeRequest(endpoint) { (result: Result<[CoinGeckoCurrencyModel]>) in
            switch result {
            case .success(let objects):
                (inject() as LoaderInterface).hide()
                guard let object = objects.first else { return }
                let currentPrice = object.currentPrice
                let totalValue = currentPrice * value
                convertedValue(totalValue)
            case .failure(let error):
                (inject() as LoaderInterface).showError(message: error.localizedDescription)
            }
        }
    }
}
