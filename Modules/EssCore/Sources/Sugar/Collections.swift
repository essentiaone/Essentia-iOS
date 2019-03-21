//
//  Collections.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/21/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public func collect<A>(_ elements: [[A]]) -> [A] {
    return elements.flatMap { return $0 }
}
