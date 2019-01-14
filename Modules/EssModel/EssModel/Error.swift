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
    case wrongPassword
    
    public var localizedDescription: String {
        switch self {
        case .txError(let txError):
            switch txError {
            case .invalidPk:
                return "Invalid private key"
            }
        case .unknownError:
            return "Something wrong"
        case .unexpectedBehavior:
            return "Unexpected behavour, write to support"
        case .wrongPassword:
            return "Wrong password, try again!"
        }
    }
}
