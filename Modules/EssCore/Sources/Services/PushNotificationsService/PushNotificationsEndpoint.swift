//
//  PushNotificationsEndpoint.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/12/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

enum PushNotificationsEndpoint: RequestProtocol {
    case updateToken(token: String, userIds: [String])
    
    var path: String {
        switch self {
        case .updateToken:
            return "api/token/add/"
        default:
            return ""
        }
    }
    
    var extraHeaders: HTTPHeader? {
        return nil
    }
    
    var parameters: HTTParametrs? {
        switch self {
        case .updateToken(let token, _):
            return ["token": token,
                    "device": "none"]
        default:
            return [:]
        }
    }
    
    var requestType: RequestType {
        switch self {
        case .updateToken:
            return .post
        default:
            return .get
        }
    }
    
    var contentType: RequestContentType {
        return .json
    }
}
