//
//  Currencies.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum FiatCurrency: String, Codable, Equatable, Hashable {
    case usd
    case eur
    case krw
    case cny
    
    var titleString: String {
        switch self {
        case .usd:
            return LS("Currency.usd")
        case .eur:
            return LS("Currency.eur")
        case .krw:
            return LS("Currency.krw")
        case .cny:
            return LS("Currency.cny")
        }
    }
    
    var symbol: String {
        switch self {
        case .usd:
            return "$"
        case .eur:
            return "€"
        case .krw:
            return "₩"
        case .cny:
            return "¥"
        }
    }
    
    static var cases: [FiatCurrency] {
        return [.usd, .eur, .krw, .cny]
    }
}
