//
//  User.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class User: Codable {
    static var notSigned = User(mnemonic: "")
    
    let id: String
    let seed: String
    var mnemonic: String?
    var name: String?
    var currentlyBackuped: [BackupType] = []
    
    convenience init(mnemonic: String) {
      let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
      self.init(seed: seed)
      self.mnemonic = mnemonic
    }
    
    init(seed: String) {
        self.seed = seed
        self.id = String(Date().timeIntervalSince1970)
        self.currentlyBackuped = []
    }
    
    var dislayName: String {
        return name ?? String(seed.suffix(4))
    }
}
