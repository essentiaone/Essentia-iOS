//
//  RealmUserStorage.swift
//  EssStore
//
//  Created by Pavlo Boiko on 1/20/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import RealmSwift
import EssModel
import EssDI
import EssDI

fileprivate struct Constants {
    static var storageFolder = "Users"
}

public class RealmUserStorage: UserStorageServiceInterface {
    let realm: Realm
    private let seedHash: String
    
    required public convenience init(user: User, password: String) throws {
        let seedHash = user.seed.sha256()
        do {
            try self.init(seedHash: seedHash, password: password)
            try realm.write {
                realm.add(user)
            }
        }
    }
    
    required public init(seedHash: String, password: String) throws {
        self.seedHash = seedHash
        let key = Data(hex: password.sha256())
        let defaultConfig = Realm.Configuration.defaultConfiguration
        guard let defaultUrl = defaultConfig.fileURL else {
            throw EssentiaError.dbError(.databaseNotFound)
        }
        let url = defaultUrl.deletingLastPathComponent().appendingPathComponent(Constants.storageFolder).appendingPathComponent("\(seedHash).realm")
        let config = Realm.Configuration(fileURL: url, encryptionKey: key, readOnly: false, schemaVersion: 0, objectTypes: [User.self])
        do {
            self.realm = try Realm(configuration: config)
        } catch {
            (inject() as LoggerService).log("Database Not Loaded, \(error.localizedDescription)", level: .error)
            self.realm = try Realm()
        }
    }
    
    public func get() -> User {
        return realm.object(ofType: User.self, forPrimaryKey: seedHash)!
    }
    
    public func remove() {
        realm.deleteAll()
    }
    
    public func update(_ updateBlock: (User) -> Void) {
        do {
            try realm.write {
                updateBlock(get())
            }
        } catch {
            (inject() as LoggerService).log("Fieled to update user, \(error.localizedDescription)", level: .error)
        }
    }
    
}
public func storeCurrentUser() {
    
}
