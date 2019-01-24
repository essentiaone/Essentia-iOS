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

public class ViewUserStorageService: UserListStorageServiceInterface {
    let realm: Realm
    
    public init() {
        let defaultConfig = Realm.Configuration.defaultConfiguration
        let url = defaultConfig.fileURL!.deletingLastPathComponent().appendingPathComponent("ViewUsers.realm")
        let config = Realm.Configuration(fileURL: url, readOnly: false)
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
    
    public func get() -> [ViewUser] {
        return realm.objects(ViewUser.self).map({ return $0 })
    }
    
    public func update(_ updateBlock: (ViewUser) -> Void) {
        
    }
}
