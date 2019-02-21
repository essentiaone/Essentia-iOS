//
//  Token.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

@objcMembers
public class Token: Object, Codable {
    dynamic public var id: String = ""
    dynamic public var address: String = ""
    dynamic public var symbol: String = ""
    dynamic public var name: String = ""
    dynamic public var decimals: Int = 0
    dynamic public var path: TokenIcons?
    
    public convenience init(id: String, address: String, symbol: String, name: String, decimals: Int, path: TokenIcons?) {
        self.init()
        self.id = id
        self.address = address
        self.symbol = symbol
        self.name = name
        self.decimals = decimals
        self.path = path
    }
}
