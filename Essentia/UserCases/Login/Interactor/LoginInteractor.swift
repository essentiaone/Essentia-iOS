//
//  LoginInteractor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class LoginInteractor: LoginInteractorInterface {
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var mnemonicService: MnemonicServiceInterface = inject()
    
    func generateNewUser() {
        let currentLocaleLanguage = mnemonicService.languageForCurrentLocale()
        let mnemonic = mnemonicService.newMnemonic(with: currentLocaleLanguage)
        EssentiaStore.currentUser = User(mnemonic: mnemonic)
    }
}
