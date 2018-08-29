//
//  User.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class User: NSObject, Codable {
    static var notSigned = User(mnemonic: "")
    
    let id: String
    let seed: String
    var mnemonic: String?
    var name: String?
    var currency: Currency
    var imageData: Data?
    var language: LocalizationLanguage
    var currentlyBackedUp: [BackupType] = []
    var loginMethod: BackupType = .none
    var keystoreUrl: URL?
    
    convenience init(mnemonic: String) {
      let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
      self.init(seed: seed)
      self.mnemonic = mnemonic
    }
    
    convenience init(seed: String, image: UIImage, name: String) {
        self.init(seed: seed)
        self.name = name
        self.imageData = UIImageJPEGRepresentation(image, 1.0)
    }
    
    init(seed: String) {
        self.seed = seed
        self.id = String(Int(Date().timeIntervalSince1970))
        self.currentlyBackedUp = []
        self.currency = .usd
        self.imageData = UIImageJPEGRepresentation(UIImage(named: "testAvatar")!, 1.0)!
        self.language = LocalizationLanguage.defaultLanguage
    }
    
    var dislayName: String {
        return name ?? String(seed.suffix(4))
    }
    
    var icon: UIImage {
        guard let data = imageData,
              let image = UIImage(data: data) else {
            return #imageLiteral(resourceName: "testAvatar")
        }
        return image
    }
}
