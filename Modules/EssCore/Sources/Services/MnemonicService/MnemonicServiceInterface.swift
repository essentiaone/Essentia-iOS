//
//  MnemonicServiceInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel

public protocol MnemonicServiceInterface {
    func wordList() -> [String]
    func wordList(with language: MnemonicLanguage) -> [String]
    func newMnemonic(with language: MnemonicLanguage) -> String
    func seed(from mnemonic: String) -> String
    func keyStoreFile(mnemonic: String, password: String) throws -> Data
    func mnemonic(from keystoreFile: Data, password: String) throws -> String
    func languageForCurrentLocale() -> MnemonicLanguage
}
