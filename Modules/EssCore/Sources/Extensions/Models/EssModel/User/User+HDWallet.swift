//
//  User+HDWallet.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import EssResources
import EssModel

extension User {
    public convenience init(mnemonic: String, index: Int, name: String) {
        let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
        let icon = (inject() as AppImageProviderInterface).testAvatar
        self.init(seed: seed, index: index, image: icon, name: name)
        self.encodedMnemonic = User.encrypt(data: mnemonic, password: User.defaultPassword)
    }
    
    public convenience init(mnemonic: String) {
        let index = (inject() as UserStorageServiceInterface).freeIndex
        let name = LS("Settings.CurrentAccountTitle.Default") + " (\(index))"
        self.init(mnemonic: mnemonic, index: index, name: name)
    }
    
    public convenience init(seed: String) {
        let index = (inject() as UserStorageServiceInterface).freeIndex
        let name = LS("Settings.CurrentAccountTitle.Default") + " (\(index))"
        let icon = (inject() as AppImageProviderInterface).testAvatar
        self.init(seed: seed, index: index, image: icon, name: name)
        
    }
}
