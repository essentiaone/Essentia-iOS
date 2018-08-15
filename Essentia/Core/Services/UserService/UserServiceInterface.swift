//
//  UserServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol UserServiceInterface {
    func get() throws -> [User]
    func store(user: User) throws
    func remove(user: User) throws
}
