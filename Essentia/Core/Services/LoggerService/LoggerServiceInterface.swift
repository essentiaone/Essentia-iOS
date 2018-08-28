//
//  LoggerServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 28.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public enum LogLevel {
    case debug
    case info
    case warning
    case error
}

public protocol LoggerServiceInterface {
    func log(_ message: String)
    func log(_ message: String, level: LogLevel)
}

extension LoggerServiceInterface {
    public func log(_ message: String) {
        log(message, level: .debug)
    }
}
