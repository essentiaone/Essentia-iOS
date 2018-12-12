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

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application
    (
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        Fabric.with([Crashlytics.self])
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = WelcomeViewController()
        SwizzleLocalizedFiles()
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
    
    }
}
