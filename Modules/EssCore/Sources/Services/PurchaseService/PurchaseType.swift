//
//  PurchaseType.swift
//  EssCore
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public enum PurchaseType {
    case unlimited
    case singeAccount(Int)
    case notPurchased
    case error(Error)
}

public enum PurchasePrice: Double {
    case unlimited = 250
    case single = 25
}
