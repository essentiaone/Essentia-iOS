//
//  Collections.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/21/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

// Collect
public func collect<A>(_ elements: [[A]]) -> [A] {
    return elements.flatMap { return $0 }
}

// Apply
precedencegroup ForwardApplication {
    associativity: left
}

infix operator |>: ForwardApplication

public func |> <A, B>(a: A, f: (A) -> B) -> B {
    return f(a)
}

// Union of functions
precedencegroup ForwardComposition {
    associativity: left
    higherThan: ForwardApplication
}

infix operator >>>: ForwardComposition

public func >>> <A, B, C>(f: @escaping (A) -> B, g: @escaping (B) -> C) -> ((A) -> C) {
    return { a in
        g(f(a))
    }
}
