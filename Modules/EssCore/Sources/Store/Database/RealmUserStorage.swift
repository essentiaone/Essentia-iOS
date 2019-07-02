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
import Foundation

fileprivate struct Constants {
    static var storageFolder = "Users"
}

public class RealmUserStorage: UserStorageServiceInterface {
    private let seedHash: String
    private let config: Realm.Configuration
    
    required public convenience init(user: User, password: String) throws {
        let seedHash = user.seed.sha256()
        do {
            try self.init(seedHash: seedHash, password: password)
            try autoreleasepool {
                let realm = try! Realm(configuration: config)
                try realm.write {
                    realm.add(user)
                }
            }
            let index = (inject() as ViewUserStorageServiceInterface).freeIndex
            let passwordHash = password.sha512().sha512()
            let viewUser = ViewUser(id: seedHash, index: index, name: user.profile?.name ?? "", icon: user.profile?.imageData, passwordHash: passwordHash)
            (inject() as ViewUserStorageServiceInterface).add(viewUser)
        }
    }
    
    required public init(seedHash: String, password: String) throws {
        (inject() as LocalFilesServiceInterface).createFolder(path: .final(Constants.storageFolder))
        self.seedHash = seedHash
        let key = Data(hex: password.sha512())
        let defaultConfig = Realm.Configuration.defaultConfiguration
        guard let defaultUrl = defaultConfig.fileURL else {
            throw EssentiaError.dbError(.databaseNotFound)
        }
        let url = defaultUrl.deletingLastPathComponent().appendingPathComponent(Constants.storageFolder).appendingPathComponent("\(seedHash).realm")
        self.config = Realm.Configuration(fileURL: url, encryptionKey: key, readOnly: false, schemaVersion: 2)
        _ = try Realm(configuration: config)
    }
    
    public var getOnly: User {
        let realm = try! Realm(configuration: config)
        return realm.object(ofType: User.self, forPrimaryKey: seedHash)!
    }
    
    public func get(_ user: @escaping (User) -> Void) {
        autoreleasepool {
            user(self.get())
        }
    }
    
    private func get() -> User {
        let realm = try! Realm(configuration: config)
        return realm.object(ofType: User.self, forPrimaryKey: seedHash)!
    }
    
    public func remove() {
        autoreleasepool {
            let realm = try! Realm(configuration: config)
            realm.deleteAll()
            let dbPath = LocalFolderPath.subFolder("Users", .final(getOnly.id))
            try? (inject() as LocalFilesServiceInterface).removeFile(at: dbPath, with: "")
        }
    }
    
    public func update(_ updateBlock: @escaping (User) -> Void) {
        do {
            try autoreleasepool {
                let realm = try! Realm(configuration: config)
                try realm.write {
                    updateBlock(self.get())
                }
            }
        } catch {
            (inject() as LoggerService).log("Fieled to update user, \(error.localizedDescription)", level: .error)
        }
    }
    
    public func realmQueue(_ block: @escaping () -> Void ) {
        DispatchQueue(label: Constants.storageFolder).async {
            block()
        }
    }
    
    public func close() {
        
    }
}
