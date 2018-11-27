//
//  Collection+SafeSubscript.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/27/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
