//
//  CurrencyConverterServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

public protocol CurrencyConverterServiceInterface {
    func convertBalance(value: Double, from asset: AssetInterface, to currency: FiatCurrency, convertedValue: @escaping (Double) -> Void)
    func getPrice(for asset: AssetInterface, in currency: FiatCurrency, price: @escaping (Double) -> Void)
    func getCoinInfo(from asset: AssetInterface, to currency: FiatCurrency, info: @escaping (CoinGeckoCurrencyModel) -> Void)
}
