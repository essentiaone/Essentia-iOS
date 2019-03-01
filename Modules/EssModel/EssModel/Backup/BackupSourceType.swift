//
//  BackupSourceType.swift
//  EssModel
//
//  Created by Pavlo Boiko on 3/1/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public enum BackupSourceType: Int {
    case app
    case web
    case jaxx
    case metaMask
    case exodus
    case wallet
    
    public var shouldCrateWalletsWhenCreate: Bool {
        switch self {
        case .app:
            return false
        default:
            return true
        }
    }
}
