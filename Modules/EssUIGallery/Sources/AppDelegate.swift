//
//  AppDelegate.swift
//  EssUIGallery
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import EssResources
import EssCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = ViewController()
        
        loadColorSheme()
        loadImageSheme()
        SwizzleLocalizedFiles()
        return true
    }

    // MARK: - Assets
    private func loadImageSheme() {
        let injection: AppImageProviderInterface = AppImageProvider()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadColorSheme() {
        let injection: AppColorInterface = DefaultColorSheme()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
}
