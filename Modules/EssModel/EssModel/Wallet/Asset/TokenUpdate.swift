//
//  TokenUpdate.swift
//  EssModel
//
//  Created by Pavlo Boiko on 2/15/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class TokenUpdate: Object {
    public dynamic var updateTime: Double = 0
    public dynamic var tokens: List<Token> = List()
    
    public convenience init(updateTime: Double, tokens: List<Token>) {
        self.init()
        self.updateTime = updateTime
        self.tokens = tokens
    }
}
