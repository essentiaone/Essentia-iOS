//
//  EtherTxInfo.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/14/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct EtherTxInfo {
    var address: String
    var ammount: SelectedTransacrionAmmount
    var data: String
    var fee: Double
    var gasPrice: Int
    var gasLimit: Int
}
