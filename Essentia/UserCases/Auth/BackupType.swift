//
//  BackupType.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum AuthType {
    case login
    case backup
}

enum BackupType: Int, Codable {
    case mnemonic = 15
    case seed = 35
    case keystore = 50
    case none = 0
    
    var titleString: String {
        switch self {
        case .mnemonic:
            return LS("BackupType.Mnemonic")
        case .seed:
            return LS("BackupType.Seed")
        case .keystore:
            return LS("BackupType.Keystore")
        case .none:
            return LS("BackupType.None")
        }
    }
}
