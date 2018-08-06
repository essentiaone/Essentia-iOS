//
//  MnemonicProviderInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum Language {
    case english
    case japanese
    case korean
    case spanish
    case simplifiedChinese
    case traditionalChinese
    case french
    case italian

}

protocol MnemonicProviderInterface {
    init(language: Language)
    var mnemonic: String { get }
    var wordList: [String] { get }
}
