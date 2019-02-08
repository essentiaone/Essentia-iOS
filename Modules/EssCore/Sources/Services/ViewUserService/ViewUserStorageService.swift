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
        self.realm = try! Realm()
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
    
    public func get() -> [ViewUser] {
        return realm.objects(ViewUser.self).map({ return $0 })
    }
    
    public func update(_ updateBlock: (ViewUser) -> Void) {
        let currentUserId = EssentiaStore.shared.currentUser.id
        let viewUser = get().first {
            return $0.id == currentUserId
        }
        guard let user = viewUser else { return }
        try? realm.write {
            updateBlock(user)
        }
    }
}
