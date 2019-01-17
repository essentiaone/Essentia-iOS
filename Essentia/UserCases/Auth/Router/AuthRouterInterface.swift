//
//  AuthRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssUI

protocol AuthRouterInterface: class {
    init(navigationController: UINavigationController, type: BackupType, auth: AuthType, delegate: SelectAccountDelegate)
    func showNext()
    func showPrev()
}
