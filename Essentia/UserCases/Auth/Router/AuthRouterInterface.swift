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
import EssCore

public protocol AuthRouterInterface: class {
    init(navigationController: UINavigationController,
         type: BackupType,
         auth: AuthType,
         delegate: SelectAccountDelegate,
         sourceType: BackupSourceType)
    func showNext()
    func showPrev()
}
