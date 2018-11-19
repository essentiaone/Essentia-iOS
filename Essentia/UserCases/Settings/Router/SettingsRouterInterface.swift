//
//  SettingsRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum SettingsRoutes {
    case accountStrength
    case backupMenmonic
    case backupSeed
    case backupKeystore
    case language
    case currency
    case security 
    case switchAccount(callBack: () -> Void)
    case backup(type: BackupType)
    case activity(fileUrl: URL)
    case loginType
    case accountName
    case fullSecured
}

protocol SettingsRouterInterface: BaseRouterInterface {
    func show(_ route: SettingsRoutes)
    func logOut()
}
