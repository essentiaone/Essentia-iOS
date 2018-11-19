//
//  TokensService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

class TokenService: TokensServiceInterface {
    let networkManager: NetworkManager = NetworkManager("https://clogos.essdev.info")
    
    func getTokensList(_ callBack: @escaping ([Token]) -> Void) {
        networkManager.makeAsyncRequest(TokensEndpoint.list) { (result: Result<[Token]>) in
            switch result {
            case .success(let object):
                main {
                    callBack(object)
                }
            default: return
            }
        }
    }
}
