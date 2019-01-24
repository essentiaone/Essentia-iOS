//
//  CurrentCredentials.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/20/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public struct CurrentCredentials {
    public static var none = CurrentCredentials(seed: "", mnemonic: nil)
    
    public var seed: String
    public var mnemonic: String?
}
