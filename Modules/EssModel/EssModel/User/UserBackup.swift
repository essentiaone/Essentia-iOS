//
//  UserBackup.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class UserBackup: Object {
    dynamic public var currentlyBackup: CurrentlyBackup? = CurrentlyBackup()
    dynamic public var keystorePath: String?
}
