//
//  WalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public protocol WalletInterface {
    var address: String { get }
    var privateKey: String { get }
    var asset: AssetInterface { get }
    var name: String { get set }
}
