//
//  PurchaseNetworkingService.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssModel

public class PurchaseNetworkingService: PurchcaseNetworkingServiceInterface {
    private let network: NetworkManagerInterface
    
    public init() {
        network = NetworkManager("https://clogos.essdev.info")
    }
    
    public func purchaseAddress(response: @escaping (NetworkResult<PurchaseAddress>) -> Void) {
        network.request(PurchaseNetworingEndpoint.purchaseAmmount, result: response)
    }
    
    public func purchaseAmmount(response: @escaping (Double, Double) -> Void) {
        
    }
}
