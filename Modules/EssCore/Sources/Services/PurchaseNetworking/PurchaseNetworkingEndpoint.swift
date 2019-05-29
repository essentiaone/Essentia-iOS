//
//  PurchaseNetworkingEndpoint.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

public enum PurchaseNetworingEndpoint: RequestProtocol {
    case purchaseAddress
    case purchaseAmmount
    
    public var path: String {
        switch self {
        case .purchaseAddress:
            return "/essaddress"
        case .purchaseAmmount:
            return ""
        }
    }
    
    public var extraHeaders: HTTPHeader? { return nil }
    public var parameters: HTTParametrs? { return nil }
    public var requestType: RequestType { return .get }
    public var contentType: RequestContentType { return .json }
}
