//
//  BlockchainWrapperServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/4/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol BlockchainWrapperServiceInterface {
    func getBalance(for asset: AssetInterface, address: String, balance: @escaping (Double) -> Void)
}
