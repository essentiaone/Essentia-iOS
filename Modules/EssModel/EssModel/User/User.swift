//
//  User.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//
 
import UIKit
import RealmSwift

@objc
public class User: Object {
    @objc dynamic public var id: String = ""
    @objc dynamic public var profile: UserProfile? = UserProfile()
    @objc dynamic public var backup: UserBackup? = UserBackup()
    @objc dynamic public var userEvents: UserEvents? = UserEvents()
    @objc dynamic public var wallet: UserWallet? = UserWallet()
    @objc dynamic public var seed: String = ""
    @objc dynamic public var mnemonic: String? 
    
    public convenience init(id: String, seed: String, image: UIImage, name: String) {
        self.init()
        self.profile = UserProfile(image: image, name: name)
        self.id = id
        self.seed = seed
    }
    
    override public class func primaryKey() -> String? {
        return "id"
    }
}
