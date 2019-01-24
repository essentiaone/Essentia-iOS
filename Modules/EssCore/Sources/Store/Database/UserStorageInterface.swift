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
    init(user: User, password: String) throws
    init(seedHash: String, password: String) throws
    func update(_ updateBlock: (User) -> Void)
    func get() -> User
    func remove()
}

public protocol UserListStorageServiceInterface {
    func add(_ user: ViewUser)
    func remove(_ user: ViewUser)
    func get() -> [ViewUser]
    func update(_ updateBlock: (ViewUser) -> Void)
}

extension UserListStorageServiceInterface {
    public var freeIndex: Int {
        var index: Int = 0
        let users = get()
        guard !users.isEmpty else { return 0 }
        while index < Int.max {
            if users.contains(where: { $0.index == index }) {
                index++
            }
            return index
            
        }
        fatalError("Maximum user reached")
    }
}
