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

class UserStorageService: UserStorageServiceInterface, AppStateEventHandler {
    // MARK: - Dependences
    private lazy var fileSerice: LocalFilesServiceInterface = inject()
    private lazy var appEventProxy: AppStateEventProxyInterface = inject()
    let folderPath: LocalFolderPath = .final(Constants.storageFolder)
    
    init() {
        appEventProxy.add(subscriber: self, for: [.willResignActive])
    }
    
    func get() -> [User] {
        do {
            return try fileSerice.getFilesInFolder(path: folderPath)
        } catch {
            (inject() as LoggerServiceInterface).log(error.localizedDescription)
            return []
        }
    }
    
    func store(user: User) {
        guard user != .notSigned else { return }
        do {
            _ = try fileSerice.storeFile(file: user, to: folderPath, with: user.id)
        } catch {
            (inject() as LoggerServiceInterface).log(error.localizedDescription)
        }
    }
    
    func remove(user: User) {
        do {
            if fileSerice.storageContainFile(at: folderPath, with: user.id) {
                try fileSerice.removeFile(at: folderPath, with: user.id)
            }
        } catch {
            (inject() as LoggerServiceInterface).log(error.localizedDescription)
        }
    }
    
    func storeCurrentUser() {
        store(user: EssentiaStore.shared.currentUser)
    }
    
    var freeIndex: Int {
        var index = 0
        let users = get()
        guard !users.isEmpty else { return 0 }
        while true {
            guard users.contains(where: { $0.index == index }) else {
                return index
            }
            index++
        }
    }
    
    // MARK: - AppStateEventHandler
    func receive(event: AppStates) {
        switch event {
        case .willResignActive:
            if EssentiaStore.shared.currentUser.backup.currentlyBackedUp.isEmpty {
                remove(user: EssentiaStore.shared.currentUser)
            }
        default: return
        }
    }
}
