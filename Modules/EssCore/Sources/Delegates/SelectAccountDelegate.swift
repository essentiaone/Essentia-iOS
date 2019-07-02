//
//  SelectAccountDelegate.swift
//  EssCore
//
//  Created by Pavlo Boiko on 1/20/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

public protocol SelectAccountDelegate: class {
    func didSelectUser(_ user: ViewUser)
    @discardableResult func didSetUser(user: User) -> Bool
    func createNewUser()
    func didDelete(userId: String)
}
