//
//  MnemonicServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

enum MnemonicLanguage {
    case english
    case japanese
    case korean
    case spanish
    case simplifiedChinese
    case traditionalChinese
    case french
    case italian
}

protocol MnemonicServiceInterface {
    func wordList() -> [String]
    func wordList(with language: MnemonicLanguage) -> [String]
    func newMnemonic(with language: MnemonicLanguage) -> String
    func seed(from mnemonic: String) -> String
    func languageForCurrentLocale() -> MnemonicLanguage
}
