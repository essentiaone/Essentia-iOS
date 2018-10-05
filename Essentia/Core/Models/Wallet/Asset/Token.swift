//
//  Token.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

struct Token: Codable, AssetInterface {
    var address: String
    var symbol: String
    var name: String
    var decimals: Int
}
