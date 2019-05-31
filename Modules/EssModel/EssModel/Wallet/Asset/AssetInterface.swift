//
//  AssetInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.09.18
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

public enum CryptoType {
    case coin
    case token
}

public enum CurrencyType {
    case fiat
    case crypto
    
    public var another: CurrencyType {
        switch self {
        case .fiat:
            return .crypto
        case .crypto:
            return .fiat
        }
    }
}

public protocol AssetInterface {
    var name: String { get }
    var localizedName: String { get }
    var symbol: String { get }
    var iconUrl: URL { get }
    var type: CryptoType { get }
    var shadowColor: UIColor { get }
    var minimumTransactionAmmount: Double { get }
    
    func isValidAddress(_ address: String) -> Bool
}

public func==(lhs: AssetInterface, rhs: AssetInterface) -> Bool {
    return lhs.name == rhs.name && lhs.type == rhs.type && lhs.localizedName == rhs.localizedName
}
