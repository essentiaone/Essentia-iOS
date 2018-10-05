//
//  CurrencyConverterService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaNetworkCore

fileprivate struct Constants {
    static var sourceUrl = "https://api.coingecko.com/api/v3"
    static var rankPath = "CurrencyRanks"
}

class CurrencyConverterService: CurrencyConverterServiceInterface {
    let networkManager: NetworkManager
    let fileStorage: LocalFilesServiceInterface
    
    init() {
        networkManager = NetworkManager(Constants.sourceUrl)
        fileStorage = LocalFilesService()
    }
    
    func convertBalance(value: Double, from asset: AssetInterface, to currency: Currency, convertedValue: @escaping (Double) -> Void) {
        getPrice(for: asset, in: currency) { (price) in
            convertedValue(price * value)
        }
    }
    
    func getPrice(for asset: AssetInterface, in currency: Currency, price: @escaping (Double) -> Void) {
        getCoinInfo(from: asset, to: currency) { (info) in
            price(info.currentPrice)
        }
    }
    
    private func getCoinInfo(from asset: AssetInterface, to currency: Currency, info: @escaping (CoinGeckoCurrencyModel) -> Void) {
        let endpoint = CurrencyConverterEndpoint.getPrice(forCoin: asset.name.formattedCoinName, inCurrency: currency)
        networkManager.makeRequest(endpoint) { (result: Result<[CoinGeckoCurrencyModel]>) in
            switch result {
            case .success(let objects):
                guard let object = objects.first else { return }
                self.storeCoinInfo(object, from: asset, to: currency)
                info(object)
            case .failure(let error):
                (inject() as LoaderInterface).showError(message: error.localizedDescription)
            }
        }
        guard let stored = getCoinInfoFromStorage(from: asset, to: currency) else { return }
        info(stored)
    }
    
    private func storeCoinInfo(_ info: CoinGeckoCurrencyModel, from asset: AssetInterface, to currency: Currency) {
        _ = try? fileStorage.storeFile(file: info, to: path(with: asset), with: currency.rawValue)
    }
    
    private func getCoinInfoFromStorage(from asset: AssetInterface, to currency: Currency) -> CoinGeckoCurrencyModel? {
        return try? fileStorage.getFile(path: path(with: asset), name: currency.rawValue)
    }
    
    private func path(with asset: AssetInterface) -> LocalFolderPath {
        return LocalFolderPath.subFolder(Constants.rankPath, .final(asset.name))
    }
}
