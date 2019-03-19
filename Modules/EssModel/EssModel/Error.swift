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
    
    public enum DBError: Error {
        case notCreated
        case databaseNotFound
        case objectsNotFound
    }
    
    case dbError(DBError)
    case txError(TxError)
    case unknownError
    case unexpectedBehavior
    case wrongPassword
    case userExist
    
    public var localizedDescription: String {
        switch self {
        case .dbError(let dbError):
            switch dbError {
            case .databaseNotFound:
                return "Datatabase not foud"
            case .notCreated:
                return "Can not create database"
            case .objectsNotFound:
                return "Database is empty"
            }
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
        case .userExist:
            return "User already exist!"
        }
    }
}
