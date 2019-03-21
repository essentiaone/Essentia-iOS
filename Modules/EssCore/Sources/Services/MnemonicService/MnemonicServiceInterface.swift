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
    func keyStoreFile(stringData: String, passwordData: Data) throws -> Data
    func data(from keystoreFile: Data, passwordData: Data) throws -> Data
    func languageForCurrentLocale() -> MnemonicLanguage
}
