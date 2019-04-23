//
//  GCD.swift
//  EssCore
//
//  Created by Pavlo Boiko on 4/2/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public func main(_ f: @escaping () -> Void) {
    DispatchQueue.main.async {
        f()
    }
}

public func |> <V>(q: DispatchQueue, f: (V, (V) -> Void)) {
   apply(queue: q, v: f.0, f: f.1)
}

public func apply<V>(queue: DispatchQueue, v: V, f: @escaping (V) -> Void) {
    queue.async {
        f(v)
    }
}
