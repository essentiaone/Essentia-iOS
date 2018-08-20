//
//  BackupType.swift
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
