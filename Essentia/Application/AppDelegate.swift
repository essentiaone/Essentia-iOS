//
//  AppDelegate.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import Crashlytics
import Fabric
import EssCore

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    // MARK: - Dependencies
    private lazy var appStateEventProxy: AppStateEventProxyInterface = inject()
    
    func application
    (
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Fabric.with([Crashlytics.self])
        
        appStateEventProxy.didFinishLaunching(application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = WelcomeViewController()
        SwizzleLocalizedFiles()
        return true
    }
    
    // MARK: - AppEvents
    func applicationDidEnterBackground(_ application: UIApplication) {
        appStateEventProxy.applicationDidEnterBackground(application)
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        appStateEventProxy.applicationWillEnterForeground(application)
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        appStateEventProxy.applicationDidBecomeActive(application)
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        appStateEventProxy.applicationWillResignActive(application)
    }
}
