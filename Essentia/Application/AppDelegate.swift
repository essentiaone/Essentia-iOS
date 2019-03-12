//
//  AppDelegate.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssDI
import Crashlytics
import Fabric
import UserNotifications
import FirebaseCore
import FirebaseMessaging

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    // MARK: - Dependencies
    private lazy var appStateEventProxy: AppStateEventProxyInterface = inject()
    
    func application
        (
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
        ) -> Bool {
        FirebaseApp.configure()
        Fabric.with([Crashlytics.self])
        appStateEventProxy.didFinishLaunching(application)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = WelcomeViewController()
        
        SwizzleLocalizedFiles()
        registerForRemoteNotifications(application)
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
    
    // MARK: - Notifications
    func registerForRemoteNotifications(_ application: UIApplication) {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().delegate = self
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _
                    
                    in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        application.registerForRemoteNotifications()
        Messaging.messaging().delegate = self
    }
    
    // MARK: - UNUserNotificationCenterDelegate
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        (inject() as LoggerServiceInterface).log(error.localizedDescription, level: .error)
    }
    
    // MARK: - MessagingDelegate
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        (inject() as PushNotificationsServiceInterface).updateToken(fcmToken: fcmToken)
        (inject() as LoggerServiceInterface).log("FCM Token: " + fcmToken, level: .info)
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        (inject() as LoggerServiceInterface).log("Remote messae: " + remoteMessage.appData.description, level: .info)
    }
}
