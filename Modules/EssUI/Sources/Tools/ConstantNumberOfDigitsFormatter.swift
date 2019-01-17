//
//  ConstantNumberOfDigitsFormatter.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/17/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
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
