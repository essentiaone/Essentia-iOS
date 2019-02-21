//
//  TokensService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore
import EssModel
import RealmSwift

public class TokenService: TokensServiceInterface {
    let networkManager: NetworkManager = NetworkManager("https://clogos.essdev.info")
    public init() {}
    
    public func getTokensList(_ callBack: @escaping ([Token]) -> Void) {
        networkManager.makeAsyncRequest(TokensEndpoint.list) { (result: NetworkResult<[Token]>) in
            switch result {
            case .success(let object):
                main {
                    callBack(object)
                }
            default: return
            }
        }
    }
    
    public func updateTokensIfNeeded(_ updated: @escaping () -> Void) {
        networkManager.makeRequest(TokensEndpoint.update, result: { (data, _) in
            guard let data = data,
                  let updateDateString = String(data: data, encoding: .utf8),
                  let updateDate = Double(updateDateString) else {
                updated()
                return
            }
            let realm = try? Realm()
            guard let lastUpdate = realm?.objects(TokenUpdate.self).first else {
                self.reloadTokens(newDate: updateDate, updated)
                return
            }
            let needUpdate = lastUpdate.updateTime != updateDate
            if needUpdate {
                realm?.beginWrite()
                realm?.delete(lastUpdate)
                try? realm?.commitWrite()
                self.reloadTokens(newDate: updateDate, updated)
            } else {
                updated()
            }
        })
    }
    
    private func reloadTokens(newDate: Double, _ updated: @escaping () -> Void) {
        self.getTokensList({ (tokens) in
            let realm = try? Realm()
            let list: List<Token> = List()
            list.append(objectsIn: tokens)
            let update = TokenUpdate(updateTime: newDate, tokens: list)
            realm?.beginWrite()
            realm?.add(update)
            try? realm?.commitWrite()
            updated()
        })
    }
}
