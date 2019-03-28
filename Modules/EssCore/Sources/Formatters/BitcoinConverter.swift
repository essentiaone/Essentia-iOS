//
//  BitcoinConverter.swift
//  EssCore
//
//  Created by Pavlo Boiko on 3/18/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation

public typealias Satoshi = UInt64
public typealias Bitcoin = Double
public var satoshiesInBitcoin: Double = 100_000_000

public class BitcoinConverter {
    private let value: UInt64
    
    public init(satoshi: Satoshi) {
        self.value = satoshi
    }
    
    public init(bitcoin: Bitcoin) {
        self.value = UInt64(bitcoin * satoshiesInBitcoin)
    }
    
    public convenience init(bitcoinString: String) {
        self.init(bitcoin: Bitcoin(bitcoinString) ?? 0)
    }
    
    public convenience init(satoshiString: String) {
        self.init(satoshi: Satoshi(satoshiString) ?? 0)
    }
    
    public var inSatoshi: Satoshi {
        return value
    }
    
    public var inBitcoin: Bitcoin {
        return Double(value) / satoshiesInBitcoin
    }
}
