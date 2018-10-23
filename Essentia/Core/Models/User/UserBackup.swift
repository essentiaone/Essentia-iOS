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
    
    var isSecured: Bool {
         return currentlyBackedUp.count == 3
    }
    
    var secureLevel: Int {
        return currentlyBackedUp.count
    }
}
