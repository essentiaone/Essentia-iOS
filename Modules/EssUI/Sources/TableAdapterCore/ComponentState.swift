//
//  ComponentState.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public class ComponentState<T>: NSObject {
    public var value: T
    public var error: Swift.Error?
    
    public init(defaultValue: T, error: Error? = nil) {
        value = defaultValue
        self.error = error
    }
    
    public var localizedError: String {
        return error?.localizedDescription ?? ""
    }
    
    override public var description: String {
        return "Value: \(value),Error: \(localizedError)"
    }
}

public enum AnimationState {
    case idle
    case updating
}
