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

extension Int {
    static postfix func++(lhs: inout Int) {
        return lhs += 1
    }
    
    static postfix func--(lhs: inout Int) {
        return lhs -= 1
    }
}
