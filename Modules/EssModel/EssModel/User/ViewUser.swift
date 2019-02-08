//
//  ViewUser.swift
//  EssModel
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class ViewUser: Object {
    public dynamic var id: String = ""
    public dynamic var index: Int = 0
    public dynamic var name: String = ""
    public dynamic var icon: Data = Data()
    public dynamic var passwordHash: String = ""
    public dynamic var test: String = ""
    
    public convenience init(id: String, index: Int, name: String, icon: Data?, passwordHash: String) {
        self.init()
        self.id = id
        self.index = index
        self.name = name
        self.icon = icon ?? Data()
        self.passwordHash = passwordHash
        self.test = ""
    }
}
