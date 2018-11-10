//
//  CurrencyConverterEndpoint.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

enum CurrencyConverterEndpoint: RequestProtocol {
    var path: String {
        switch self {
        case .getPrice(let forCoin, let inCurrency):
            let currency = inCurrency.rawValue
            return "/coins/markets?vs_currency=\(currency)&ids=\(forCoin)"
        }
    }
    
    var extraHeaders: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    var requestType: RequestType {
        return .get
    }
    var contentType: RequestContentType {
        return .json
    }
    
    case getPrice(forCoin: String, inCurrency: FiatCurrency)
}
