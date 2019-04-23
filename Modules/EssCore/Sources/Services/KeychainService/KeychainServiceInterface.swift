//
//  KeychainServiceInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 4/15/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public protocol KeychainServiceInterface {
    func storePassword(userId: String, password: String, result: @escaping KeychainOperationStore)
    func getPassword(userId: String, result: @escaping KeychainOperationGet)
    func removePassword(userId: String, result: @escaping KeychainOperationRemove)
}
