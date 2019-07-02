//
//  SettingsRouterInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 1/20/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import EssModel
import UIKit

public enum SettingsRoutes {
    case accountStrength
    case language
    case currency
    case security
    case switchAccount(SelectAccountDelegate)
    case backup(type: BackupType)
    case accountName
    case fullSecured
}

public protocol SettingsRouterInterface: BaseRouterInterface {
    func show(_ route: SettingsRoutes)
    func logOut(finish: @escaping () -> Void)
    var nvc: UINavigationController? { get }
}
