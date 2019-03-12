//
//  PushNotificationsServiceInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/12/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public protocol PushNotificationsServiceInterface {
    func updateToken(fcmToken: String)
    func addWalletForNotifications(userId: String, wallet: String)
    func removeWalletForNotifications(wallet: String)
}
