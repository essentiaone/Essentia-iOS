//
//  BackupRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum BackupType {
    case mnemonic
    case seed
    case keystore
}

protocol BackupRouterInterface: class {
    init(rootController: UIViewController, mnemonic: String, type: BackupType)
    func showNext()
    func showPrev()
}
