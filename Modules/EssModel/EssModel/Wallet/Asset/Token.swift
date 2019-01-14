//
//  Token.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public struct Token: Codable {
    public var id: String
    public var address: String
    public var symbol: String
    public var name: String
    public var decimals: Int
    public var path: TokenIcons?
}
