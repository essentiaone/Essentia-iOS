//
//  LoginInteractor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssCore
import EssDI

class LoginInteractor: LoginInteractorInterface {
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var viewUserService: ViewUserStorageServiceInterface = inject()
    private lazy var mnemonicService: MnemonicServiceInterface = inject()
    private lazy var purchaseService: PurchaseServiceInterface = inject()
    
    func generateNewUser(callBack: @escaping () -> Void) {
        DispatchQueue.global().async {
            let currentLocaleLanguage = self.mnemonicService.languageForCurrentLocale()
            let mnemonic = self.mnemonicService.newMnemonic(with: currentLocaleLanguage)
            DispatchQueue.main.async {
                let user = User(mnemonic: mnemonic)
                EssentiaStore.shared.setUser(user)
                callBack()
            }
        }
    }
    
    func createNewUser(generateAccount: @escaping () -> Void, openPurchase: @escaping () -> Void) {
        let accountsCount = viewUserService.users.count
        let purchaseAddress = UserDefaults.standard.string(forKey: EssDefault.purchaseAddress.rawValue)
        
        guard accountsCount >= EssentiaConstants.freeAccountsCount else {
            generateAccount()
            return
        }
        
        guard let address = purchaseAddress else {
            openPurchase()
            return
        }
        (inject() as LoaderInterface).show()
        purchaseService.getPurchaseType(for: address) { (purchaseType) in
            (inject() as LoaderInterface).hide()
            switch purchaseType {
            case .unlimited:
                generateAccount()
            case .singeAccount(let count):
                if accountsCount <= count + EssentiaConstants.freeAccountsCount {
                    generateAccount()
                } else {
                    openPurchase()
                }
            case .notPurchased:
                openPurchase()
            }
        }
    }
}
