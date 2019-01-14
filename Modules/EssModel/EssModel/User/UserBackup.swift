//
//  UserBackup.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public class UserBackup: Codable {
    public var currentlyBackedUp: Set<BackupType> = []
    public var keystoreUrl: URL?
    
    public var isSecured: Bool {
         return currentlyBackedUp.count == 3
    }
    
    public var secureLevel: Int {
        return currentlyBackedUp.count
    }
}
