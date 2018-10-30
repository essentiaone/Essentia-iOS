//
//  ProcentsFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/26/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class ProcentsFormatter {
    static func formattedChangePer24Hours(_ procents: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.decimalSeparator = "."
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        formatter.allowsFloats = true
        return formatter.string(from: NSNumber(value: procents)) ?? "0.00%"
    }
}
