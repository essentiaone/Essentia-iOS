//
//  FastTernaryOperator.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import Swift

//Short ternar operator

infix operator ?! : AdditionPrecedence

public func ?! <T>(condition: Bool, object: T?) -> T? {
    return condition ? object : nil
}
