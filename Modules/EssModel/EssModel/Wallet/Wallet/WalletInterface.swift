//
//  WalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public protocol WalletInterface {
    func address(withSeed: String) -> String
    func privateKey(withSeed: String) -> String?
    var asset: AssetInterface { get }
    var name: String { get set }
}
