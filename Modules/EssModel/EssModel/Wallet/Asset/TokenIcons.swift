//
//  TokenIcons.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import RealmSwift

@objc
public class TokenIcons: Object, Codable {
    @objc dynamic public var x16: String?
    @objc dynamic public var x32: String?
    @objc dynamic public var x64: String?
    @objc dynamic public var x128: String?
    
    public enum CodingKeys: String, CodingKey {
        case x16 = "16x16"
        case x32 = "32x32"
        case x64 = "64x64"
        case x128 = "128x128"
    }
    
    public convenience init(x16: String?, x32: String?, x64: String?, x128: String?) {
        self.init()
        self.x16 = x16
        self.x32 = x32
        self.x64 = x64
        self.x128 = x128
    }
}
