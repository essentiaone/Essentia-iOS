//
//  Token.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import RealmSwift

@objc
public class Token: Object, Codable {
    @objc dynamic public var id: String = ""
    @objc dynamic public var address: String = ""
    @objc dynamic public var symbol: String = ""
    @objc dynamic public var name: String = ""
    @objc dynamic public var decimals: Int = 0
    @objc dynamic public var path: TokenIcons?
}
