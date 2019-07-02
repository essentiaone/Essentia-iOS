//
//  UserStorageInterface.swift
//  EssStore
//
//  Created by Pavlo Boiko on 1/22/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

public protocol UserStorageServiceInterface {
    func update(_ updateBlock: @escaping (User) -> Void)
    var getOnly: User { get }
    func get(_ user: @escaping (User) -> Void)
    func remove()
}

public class DefaultUserStorage: UserStorageServiceInterface {
    
    public init() {}
    
    public func update(_ updateBlock: @escaping (User) -> Void) {
        updateBlock(EssentiaStore.shared.currentUser)
    }
    
    public var getOnly: User {
        return EssentiaStore.shared.currentUser
    }
    
    public func get(_ user: @escaping (User) -> Void) {
        user(EssentiaStore.shared.currentUser)
    }
    
    public func remove() {}
}
