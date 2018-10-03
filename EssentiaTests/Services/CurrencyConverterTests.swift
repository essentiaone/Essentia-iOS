//
//  CurrencyConverterTests.swift
//  EssentiaTests
//
//  Created by Pavlo Boiko on 10/3/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import XCTest
@testable import Essentia

class CurrencyConverterTests: XCTestCase {
    var currencyConvertService: CurrencyConverterServiceInterface?
    
    override func setUp() {
        currencyConvertService = CurrencyConverterService()
    }
    
    func testCoinsConverter() {
        [Coin.bitcoin, .litecoin, .bitcoinCash, .ethereum].forEach {
            testConvert(coin: $0, currency: .usd)
            testConvert(coin: $0, currency: .eur)
            testConvert(coin: $0, currency: .krw)
            testConvert(coin: $0, currency: .cny)
        }
    }
    
    func testConvert(coin: Coin, currency: Currency) {
        let expectation = self.expectation(description: "Convert \(coin.name) to \(currency.rawValue)")
        currencyConvertService?.convertBalance(value: 1, from: coin.name.formattedCoinName ,
                                               to: currency, convertedValue: { (value) in
                                                XCTAssert(value >= 0)
                                                expectation.fulfill()
        })
        waitForExpectations(timeout: 10, handler: nil)
    }
    
}
