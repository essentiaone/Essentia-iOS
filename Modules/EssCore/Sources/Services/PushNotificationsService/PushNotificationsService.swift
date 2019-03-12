//
//  PushNotificationsService.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/12/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssDI

public class PushNotificationsService: PushNotificationsServiceInterface {
    private let networkManager: NetworkManager
    
    public init() {
        networkManager = NetworkManager("http://207.180.194.211:8085/")
    }
    
    public func updateToken(fcmToken: String) {
        let userService: ViewUserStorageServiceInterface = inject()
        let userIds = userService.get().map { return $0.id }
        let endpoint = PushNotificationsEndpoint.updateToken(token: fcmToken, userIds: userIds)
        networkManager.makeAsyncRequest(endpoint) { (result: NetworkResult<String>) in
            print(result)
        }
    }
    
    public func addWalletForNotifications(userId: String, wallet: String) {
        
    }
    
    public func removeWalletForNotifications(wallet: String) {
        
    }
    
    
}
