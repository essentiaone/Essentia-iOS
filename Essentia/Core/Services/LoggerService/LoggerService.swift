//
//  LoggerService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 28.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import CocoaLumberjack

public class LoggerService: LoggerServiceInterface {
    init() {
        DDLog.add(DDTTYLogger.sharedInstance)
        DDLog.add(DDASLLogger.sharedInstance)
        DDTTYLogger.sharedInstance.colorsEnabled = true
    }
    
    public func log(_ message: String, level: LogLevel) {
        switch level {
        case .debug:
            DDLogDebug(message)
        case .info:
            DDLogInfo(message)
        case .warning:
            DDLogWarn(message)
        case .error:
            DDLogError(message)
        }
    }
}
