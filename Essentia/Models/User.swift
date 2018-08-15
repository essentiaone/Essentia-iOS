//
//  User.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum BackupType: Int, Codable {
    case mnemonic
    case seed
    case keystore
}

class User: Codable {
    let id: String
    let seed: String
    let mnemonic: String?
    let name: String
    let currentlyBackuped: [BackupType]
}
