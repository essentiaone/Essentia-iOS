//
//  AuthRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol AuthRouterInterface: class {
    init(navigationController: UINavigationController, mnemonic: String, type: BackupType, auth: AuthType)
    func showNext()
    func showPrev()
}
