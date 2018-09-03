//
//  MnemonicService.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import HDWalletKit

class MnemonicService: MnemonicServiceInterface {
    func newMnemonic(with language: MnemonicLanguage) -> String {
        return Mnemonic.create(language: wrappedLanguage(for: language))
    }
    
    func seed(from mnemonic: String) -> String {
        return Mnemonic.createSeed(mnemonic: mnemonic).toHexString()
    }
    
    func wordList() -> [String] {
        return wrappedLanguage(for: languageForCurrentLocale()).words
    }
    
    func wordList(with language: MnemonicLanguage) -> [String] {
        return wrappedLanguage(for: language).words
    }
    
    func keyStoreFile(seed: String, password: String) throws -> Data {
        let keystore = try KeystoreV3(seed: Data(hex: seed), password: password)
        return (try keystore?.encodedData())!
    }
    
    func seed(from keystoeFile: Data, password: String) -> String? {
        guard let keystoreV3 = try? KeystoreV3(keyStore: keystoeFile),
              let pk = try? keystoreV3?.getDecriptedKeyStore(password: password),
              let seed = pk?.toHexString() else {
            return nil
        }
        return seed
    }
    
    func languageForCurrentLocale() -> MnemonicLanguage {
        func chinesLanguageType(for languageCode: String) -> MnemonicLanguage {
            let chinasType = languageCode.prefix(7)
            switch chinasType {
            case "zh_Hans":
                return .simplifiedChinese
            case "zh_Hant":
                return .traditionalChinese
            default:
                return .english
            }
        }
        
        guard let languageCode = Locale.current.languageCode else {
            return .english
        }
        let baseCode = languageCode.prefix(2)
        
        switch baseCode {
        case "ja":
            return .japanese
        case "ko":
            return .korean
        case "es":
            return .spanish
        case "zh":
            return chinesLanguageType(for: languageCode)
        case "fr":
            return .french
        case "it":
            return .italian
        default:
            return .english
        }
    }
    
    private func wrappedLanguage(for mnemonicLanguage: MnemonicLanguage) -> WordList {
        switch mnemonicLanguage {
        case .english:
            return WordList.english
        case .japanese:
            return WordList.japanese
        case .korean:
            return WordList.korean
        case .spanish:
            return WordList.spanish
        case .simplifiedChinese:
            return WordList.simplifiedChinese
        case .traditionalChinese:
            return WordList.traditionalChinese
        case .french:
            return WordList.french
        case .italian:
            return WordList.italian
        }
    }
}
