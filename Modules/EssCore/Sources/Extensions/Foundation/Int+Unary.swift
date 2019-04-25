//
//  Int+Unary.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

postfix operator ++
postfix operator --

public extension Int {
    static postfix func++(lhs: inout Int) {
        return lhs += 1
    }
    
    static postfix func--(lhs: inout Int) {
        return lhs -= 1
    }
    
    var string: String {
        return "\(self)"
    }
}
