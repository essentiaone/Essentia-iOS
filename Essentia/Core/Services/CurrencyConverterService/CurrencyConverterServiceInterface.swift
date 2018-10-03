//
//  CurrencyConverterServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol CurrencyConverterServiceInterface {
    func convertBalance(value: Double, from coin: String, to currency: Currency, convertedValue: @escaping (Double) -> Void)
}
