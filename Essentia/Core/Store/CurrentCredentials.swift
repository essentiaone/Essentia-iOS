//
//  CurrentCredentials.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/20/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct CurrentCredentials {
    static var none = CurrentCredentials(seed: "", mnemonic: nil)
    
    var seed: String
    var mnemonic: String?
}
