//
//  TokenIcons.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class TokenIcons: Codable {
    var x16: String?
    var x32: String?
    var x64: String?
    var x128: String?
    
    enum CodingKeys: String, CodingKey {
        case x16 = "16x16"
        case x32 = "32x32"
        case x64 = "64x64"
        case x128 = "128x128"
    }
}
