//
//  CurrencyRankDaemonInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/5/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public protocol CurrencyRankDaemonInterface {
    func update()
    func update(callBack: @escaping () -> Void)
}
