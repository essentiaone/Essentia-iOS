//
//  AssetPrice.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public struct AssetPrice {
    public var currency: FiatCurrency
    public var asset: AssetInterface
    public var price: Double
    public var yesterdayPrice: Double
}
