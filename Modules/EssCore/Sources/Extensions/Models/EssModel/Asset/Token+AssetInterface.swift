//
//  Token+Localization.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/27/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import EssModel
import UIKit

extension Token: AssetInterface {
    public var minimumTransactionAmmount: Double {
        return 1.0 / pow(10.0, Double(decimals))
    }
    
    public var shadowColor: UIColor {
        return .lightGray
    }
    
    public var localizedName: String {
        return name
    }
    
    public var type: CryptoType {
        return .token
    }
    
    public func isValidAddress(_ address: String) -> Bool {
        return address.count == 40 || address.count == 42
    }
    
    public var iconUrl: URL {
        guard let path =  path?.x128 else {
            return CoinIconsUrlFormatter(name: "Ethereum", size: .x128).url
        }
        return CoinIconsUrlFormatter.urlFromPath(path: path)
    }
}
