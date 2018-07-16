//
//  DependenceCore.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate let dIEngine = DIEngine()

public func prepareInjection<T: Any>(_ injection: T, memoryPolicy: ObjectScope) {
    let key = String(describing: T.self)
    dIEngine.load(dependence: injection as AnyObject, key: key, scope: memoryPolicy)
}

public func inject<T>() -> T {
    let key = String(describing: T.self)
    let result = dIEngine.resolve(key: key) as T?
    return result!
}
