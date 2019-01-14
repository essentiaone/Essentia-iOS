//
//  Currencies.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public enum FiatCurrency: String, Codable, Equatable, Hashable {
    case usd
    case eur
    case krw
    case cny
    
    public var symbol: String {
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
    
    public static var cases: [FiatCurrency] {
        return [.usd, .eur, .krw, .cny]
    }
}
