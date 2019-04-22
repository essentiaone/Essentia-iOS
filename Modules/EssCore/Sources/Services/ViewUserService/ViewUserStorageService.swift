//
//  UserService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import RealmSwift

public class ViewUserStorageService: ViewUserStorageServiceInterface {
    let realm: Realm
    
    public init() {
        let config = Realm.Configuration(schemaVersion: 2)
        self.realm = try! Realm(configuration: config)
    }
    
    public func add(_ user: ViewUser) {
        try? realm.write {
            realm.add(user)
        }
    }
    
    public func remove(_ user: ViewUser) {
        try? realm.write {
            realm.delete(user)
        }
    }
    
    public var users: [ViewUser] {
        return realm.objects(ViewUser.self).map({ return $0 })
    }
    
    public var current: ViewUser? {
        return realm.objects(ViewUser.self).filter({ (user) -> Bool in
            return user.id == EssentiaStore.shared.currentUser.id
        }).first
    }
    
    public func update(_ updateBlock: (ViewUser) -> Void) {
        let currentUserId = EssentiaStore.shared.currentUser.id
        let viewUser = users.first {
            return $0.id == currentUserId
        }
        guard let user = viewUser else { return }
        try? realm.write {
            updateBlock(user)
        }
    }
}
