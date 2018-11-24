//
//  Token.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct Token: Codable, AssetInterface {
    func isValidAddress(_ address: String) -> Bool {
        return address.count == 40 || address.count == 42
    }
    
    var id: String
    var address: String
    var symbol: String
    var name: String
    var decimals: Int
    var path: TokenIcons?
    
    var shadowColor: UIColor {
        return .lightGray
    }
    
    var localizedName: String {
        return name
    }
    
    var type: CryptoType {
        return .token
    }
    
    var iconUrl: URL {
        guard let path =  path?.x128 else {
            return CoinIconsUrlFormatter(name: "Ethereum", size: .x128).url
        }
        return CoinIconsUrlFormatter.urlFromPath(path: path)
    }
}
