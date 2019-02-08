//
//  User+HDWallet.swift
//  EssCore
//
//  Created by Pavlo Boiko on 12/28/18.
//  Copyright © 2018 Pavlo Boiko. All rights reserved.
//

import EssResources
import EssModel
import EssDI

extension User {
    public convenience init(mnemonic: String) {
        let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
        self.init(seed: seed)
        self.mnemonic = mnemonic
    }
    
    public convenience init(seed: String) {
        let index = (inject() as ViewUserStorageServiceInterface).freeIndex
        let name = LS("Settings.CurrentAccountTitle.Default") + " (\(index))"
        self.init(seed: seed, name: name)
    }
    
    public convenience init(mnemonic: String, name: String) {
        let seed = (inject() as MnemonicServiceInterface).seed(from: mnemonic)
        self.init(seed: seed, name: name)
        self.mnemonic = mnemonic
    }
    
    public convenience init(seed: String, name: String) {
        let icon = (inject() as AppImageProviderInterface).testAvatar
        let id = seed.sha256()
        self.init(id: id, seed: seed, image: icon, name: name)
    }
}
