//
//  UserBackup.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct UserBackup: Codable {
    var currentlyBackedUp: [BackupType] = []
    var loginMethod: BackupType = .none
    var keystoreUrl: URL?
    
    var securityLevel: Int {
        let values = currentlyBackedUp.map { return $0.rawValue }
        return values.reduce(0, +)
    }
}
