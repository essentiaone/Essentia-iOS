//
//  FiatCurrency+LS.swift
//  Essentia
//
//  Created by Pavlo Boiko on 1/10/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssCore

extension FiatCurrency {
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
}
