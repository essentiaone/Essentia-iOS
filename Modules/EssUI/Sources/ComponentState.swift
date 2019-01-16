//
//  ComponentState.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class ComponentState<T>: NSObject {
    var value: T
    var error: Swift.Error?
    
    init(defaultValue: T, error: Error? = nil) {
        value = defaultValue
        self.error = error
    }
    
    var localizedError: String {
        return error?.localizedDescription ?? ""
    }
    
    override var description: String {
        return "Value: \(value),Error: \(localizedError)"
    }
}

enum ComponentStatus {
    case idle
    case updating
}
