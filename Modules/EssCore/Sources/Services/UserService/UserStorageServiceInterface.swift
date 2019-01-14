//
//  UserStorageServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

public protocol UserStorageServiceInterface {
    func get() -> [User]
    func store(user: User)
    func remove(user: User)
    var freeIndex: Int { get }
}
