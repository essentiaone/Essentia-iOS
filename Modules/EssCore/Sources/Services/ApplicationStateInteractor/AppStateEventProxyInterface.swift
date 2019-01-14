//
//  AppStateEventProxyInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import UIKit

public enum AppStates {
    case didFinishLaunching
    case didEnterBackground
    case willEnterForeground
    case didBecomeActive
    case willResignActive
}

public protocol AppStateEventHandler: class {
    func receive(event: AppStates)
}

public protocol AppEvents: class {
    func didFinishLaunching(_ application: UIApplication)
    func applicationDidEnterBackground(_ application: UIApplication)
    func applicationWillEnterForeground(_ application: UIApplication)
    func applicationDidBecomeActive(_ application: UIApplication)
    func applicationWillResignActive(_ application: UIApplication)
}

public protocol AppStateEventProxyInterface: AppEvents {
    func add(subscriber: AppStateEventHandler, for events: [AppStates])
    func remove(subscriber: AppStateEventHandler, for events: [AppStates])
}
