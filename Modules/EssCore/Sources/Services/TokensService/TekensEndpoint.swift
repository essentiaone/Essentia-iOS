//
//  TekensEndpoint.swift
//  Essentia
//
//  Created by Pavlo Boiko on 17.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

enum TokensEndpoint: RequestProtocol {
    var path: String {
        switch self {
        case .list:
            return "/new/tokens.json"
        case .update:
            return "/new/tokens_updated_at"
        }
    }
    
    var extraHeaders: [String: String]? {
        return nil
    }
    
    var parameters: [String: Any]? {
        return nil
    }
    var requestType: RequestType {
        return .get
    }
    var contentType: RequestContentType {
        return .json
    }
    
    case list
    case update
}
