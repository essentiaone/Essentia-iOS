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
}

protocol SettingsRouterInterface {
    init(navigationController: UINavigationController)
    func show(_ route: SettingsRoutes)
    func pop()
    func logOut()
}
