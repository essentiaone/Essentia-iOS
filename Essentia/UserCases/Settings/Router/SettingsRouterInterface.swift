//
//  SettingsRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssUI

enum SettingsRoutes {
    case accountStrength
    case language
    case currency
    case security 
    case switchAccount(SelectAccountDelegate)
    case backup(type: BackupType)
    case accountName
    case fullSecured
}

protocol SettingsRouterInterface: BaseRouterInterface {
    func show(_ route: SettingsRoutes)
    func logOut()
    var nvc: UINavigationController? { get }
}
