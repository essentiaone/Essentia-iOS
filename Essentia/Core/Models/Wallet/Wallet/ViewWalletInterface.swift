//
//  ViewWalletInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol ViewWalletInterface {
    var name: String { get }
    var icon: UIImage { get }
    var symbol: String { get }
    var balanceInCurrentCurrency: String { get }
    var balance: String { get }
}
