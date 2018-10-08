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
        return "/essentia-status-bot/95d6105a210608577d30f070524deb25/raw/5bcebb6576b290e612bbd70d7188ff283fd27165/tokens.json"
    }
    
    var extraHeaders: [String : String]? {
        return nil
    }
    
    var parameters: [String : Any]? {
        return nil
    }
    var requestType: RequestType {
        return .get
    }
    var contentType: RequestContentType {
        return .json
    }
    
    case list
}
