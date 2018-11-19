//
//  User.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class User: NSObject, Codable {
    static var notSigned = User(seed: "")
    
    let id: String
    let index: Int
    var profile: UserProfile
    var backup: UserBackup = UserBackup()
    var userEvents: UserEvents = UserEvents()
    var wallet: UserWallet = UserWallet()
    let seed: String
    var mnemonic: String?
    
    convenience init(mnemonic: String) {
      let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
      self.init(seed: seed)
      self.mnemonic = mnemonic
    }
    
    convenience init(seed: String, image: UIImage, name: String) {
        self.init(seed: seed)
        self.profile = UserProfile(image: image, name: name)
    }
    
    init(seed: String) {
        self.id = String(Int(Date().timeIntervalSince1970))
        self.seed = seed
        self.profile = UserProfile()
        self.index = (inject() as UserStorageServiceInterface).freeIndex
    }
    
    var dislayName: String {
        return profile.name ?? (LS("Settings.CurrentAccountTitle.Default") + " (\(index))")
    }
}
