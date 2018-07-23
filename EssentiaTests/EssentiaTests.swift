//
//  EssentiaTests.swift
//  EssentiaTests
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import XCTest
@testable import Essentia

class EssentiaTests: XCTestCase {
    
    func testMnemonicProviderWordCountAndSymolsInWord() {
        let mnemonicProvider: MnemonicProviderInterface = MnemonicProvider()
        let wordList = mnemonicProvider.generateMnemonic()
        XCTAssert(wordList.count == 12)
        wordList.forEach { (word) in
            XCTAssert(word.count > 2)
        }
    }
    
}
