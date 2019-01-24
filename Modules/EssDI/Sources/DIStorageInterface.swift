//
//  DIStorageInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol StorageInterface {
    func add(object: RegisteredObject, key: String)
    func object(key: String) -> RegisteredObject?
    func remove(key: String)
    func all() -> [RegisteredObject]
}
