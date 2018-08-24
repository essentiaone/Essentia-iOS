//
//  Currencies.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum Currency: Int, Codable, Equatable, Hashable {
    case usd
    case eur
    case krw
    case cny
    
    var titleString: String {
        return String(describing: self).uppercased()
    }
    
    static var cases: [Currency] {
        return [.usd, .eur, .krw, .cny]
    }
}
