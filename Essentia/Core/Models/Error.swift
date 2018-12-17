//
//  Error.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/10/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public enum EssentiaError: Error {
    public enum TxError: Error {
        case invalidPk
        
    }
    case txError(TxError)
    case unknownError
    case unexpectedBehavior
}
