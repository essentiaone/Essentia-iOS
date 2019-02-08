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
    
    func isValidAddress(_ address: String) -> Bool
}

public class EmptyAsset: AssetInterface {
    public var name: String { return "" }
    public var localizedName: String { return "" }
    public var symbol: String { return "" }
    public var iconUrl: URL { return URL(fileURLWithPath: "") }
    public var type: CryptoType { return .coin }
    public var shadowColor: UIColor { return .white }
    public func isValidAddress(_ address: String) -> Bool {
        return true
    }
}
