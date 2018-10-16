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
    let networkManager: NetworkManager = NetworkManager("https://gist.githubusercontent.com")
    
    func getTokensList(_ callBack: @escaping ([Token]) -> Void) {
        (inject() as LoaderInterface).show()
        networkManager.makeAsyncRequest(TokensEndpoint.list) { (result: Result<[String:Token]>) in
            (inject() as LoaderInterface).hide()
            switch result {
            case .success(let object):
                let tokens = object.map { return $0.value }
                callBack(tokens)
            default: return
            }
        }
    }
}
