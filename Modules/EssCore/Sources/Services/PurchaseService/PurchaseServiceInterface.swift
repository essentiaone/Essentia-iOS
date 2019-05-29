//
//  PurchaseServiceInterface.swift
//  EssCore
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public protocol PurchaseServiceInterface {
    func getPurchaseType(for address: String, result: @escaping (PurchaseType) -> Void)
}
