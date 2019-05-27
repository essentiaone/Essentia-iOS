//
//  PurchaseNetworkingServiceInterface.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssModel

public protocol PurchcaseNetworkingServiceInterface {
    func purchaseAddress(response: @escaping (NetworkResult<PurchaseAddress>) -> Void)
    func purchaseAmmount(response: @escaping (Double, Double) -> Void)
    
}
