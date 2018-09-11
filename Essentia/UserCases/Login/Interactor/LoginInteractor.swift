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
    
    func generateNewUser(callBack:@escaping () -> Void) {
        DispatchQueue.global().async {
            let currentLocaleLanguage = self.mnemonicService.languageForCurrentLocale()
            let mnemonic = self.mnemonicService.newMnemonic(with: currentLocaleLanguage)
            DispatchQueue.main.async {
                let user = User(mnemonic: mnemonic)
                EssentiaStore.currentUser = user
                (inject() as UserStorageServiceInterface).store(user: user)
                callBack()
            }
        }
    }
}
