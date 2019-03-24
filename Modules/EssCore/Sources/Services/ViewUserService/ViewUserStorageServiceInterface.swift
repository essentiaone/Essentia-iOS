//
//  ViewUserStorageServiceInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 1/29/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

public protocol ViewUserStorageServiceInterface {
    func add(_ user: ViewUser)
    func remove(_ user: ViewUser)
    func update(_ updateBlock: (ViewUser) -> Void)
    var users: [ViewUser] { get }
}

extension ViewUserStorageServiceInterface {
    public var freeIndex: Int {
        var index: Int = 0
        guard !users.isEmpty else { return 0 }
        while index < Int.max {
            if users.contains(where: { $0.index == index }) {
                index++
                continue
            }
            return index
        }
        fatalError("Maximum user reached")
    }
}
