//
//  ConstantNumberOfDigitsFormatter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/22/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class ConstantNumberOfDigitsFormatter {
    private var numberFormatter: NumberFormatter
    
    init(digitsCount: Int) {
        numberFormatter = NumberFormatter()
        numberFormatter.minimumIntegerDigits = digitsCount
        numberFormatter.maximumIntegerDigits = digitsCount
    }
    
    func formateInt(int: Int) -> String {
        return formateNumber(number: NSNumber(value: int))
    }
    
    func formateNumber(number: NSNumber) -> String {
        return numberFormatter.string(from: number) ?? ""
    }
}
