//
//  AssetInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.09.18
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol AssetInterface {
    var name: String { get }
    var icon: UIImage { get }
}

extension AssetInterface where Self: Hashable {
    var hashValue: Int {
        return name.djb2hash
    }
}
