//
//  BackupType.swift
//  EssModel
//
//  Created by Pavlo Boiko on 12/26/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import Foundation

public enum AuthType {
    case login
    case backup
}

public enum BackupType: Int, Codable {
    case mnemonic
    case seed
    case keystore
    case none
    
//    var titleString: String {
//        switch self {
//        case .mnemonic:
//            return LS("BackupType.Mnemonic")
//        case .seed:
//            return LS("BackupType.Seed")
//        case .keystore:
//            return LS("BackupType.Keystore")
//        case .none:
//            return LS("BackupType.None")
//        }
//    }
}
