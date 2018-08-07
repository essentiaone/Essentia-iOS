//
//  MnemonicProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import HDWalletKit

class MnemonicProvider: MnemonicProviderInterface {
    let language: Language
    
    required init(language: Language) {
        self.language = language
    }
    
    var mnemonic: String {
        return  Mnemonic.create()
    }
    
    func seed(from mnemonic: String) -> String {
        return Mnemonic.createSeed(mnemonic: mnemonic).toHexString()
    }
    
    var wordList: [String] {
        switch language {
        case .english:
            return WordList.english.words
        case .japanese:
            return WordList.japanese.words
        case .korean:
            return WordList.korean.words
        case .spanish:
            return WordList.spanish.words
        case .simplifiedChinese:
            return WordList.simplifiedChinese.words
        case .traditionalChinese:
            return WordList.traditionalChinese.words
        case .french:
            return WordList.french.words
        case .italian:
            return WordList.italian.words
        }
    }
}
