//
//  UserService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Constants {
    static var storageFolder = "Users"
}

class UserStorageService: UserStorageServiceInterface {
    // MARK: - Dependences
    private lazy var fileSerice: LocalFilesServiceInterface = inject()
    let folderPath: LocalFolderPath = .final(Constants.storageFolder)
    
    func get() throws -> [User] {
        return try fileSerice.getFilesInFolder(path: folderPath)
    }
    
    func store(user: User) throws {
        try fileSerice.storeFile(file: user, to: folderPath, with: user.id)
    }
    
    func remove(user: User) throws {
        try fileSerice.removeFile(at: folderPath, with: user.id)
    }
}
