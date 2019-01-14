//
//  UserService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

fileprivate struct Constants {
    static var storageFolder = "Users"
}

public class UserStorageService: UserStorageServiceInterface, AppStateEventHandler {
    // MARK: - Dependences
    private lazy var fileSerice: LocalFilesServiceInterface = inject()
    private lazy var appEventProxy: AppStateEventProxyInterface = inject()
    let folderPath: LocalFolderPath = .final(Constants.storageFolder)

    public init() {
        appEventProxy.add(subscriber: self, for: [.willResignActive])
    }

    public func get() -> [User] {
        do {
            return try fileSerice.getFilesInFolder(path: folderPath)
        } catch {
            (inject() as LoggerServiceInterface).log(error.localizedDescription)
            return []
        }
    }
    
    public func store(user: User) {
        guard user != .notSigned else { return }
        do {
            _ = try fileSerice.storeFile(file: user, to: folderPath, with: user.id)
        } catch {
            (inject() as LoggerServiceInterface).log(error.localizedDescription)
        }
    }
    
    public func remove(user: User) {
        do {
            if fileSerice.storageContainFile(at: folderPath, with: user.id) {
                try fileSerice.removeFile(at: folderPath, with: user.id)
            }
        } catch {
            (inject() as LoggerServiceInterface).log(error.localizedDescription)
        }
    }
    
    public var freeIndex: Int {
        var index = 0
        let users = get()
        guard !users.isEmpty else { return 0 }
        while index < Int.max {
            guard users.contains(where: { $0.index == index }) else {
                return index
            }
            index++
        }
        fatalError("Maximum user reached")
    }
    
// MARK: - AppStateEventHandler
    public func receive(event: AppStates) {
        switch event {
        case .willResignActive:
            get().forEach { (user) in
                if user.backup.currentlyBackedUp.isEmpty {
                    remove(user: user)
                }
            }
        default: return
        }
    }
}
