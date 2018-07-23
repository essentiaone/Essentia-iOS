//
//  MnemonicProvider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import HDWalletKit

class MnemonicProvider: MnemonicProviderInterface {
    func generateMnemonic() -> String {
        //Generate mnemonic due to localization (todo)
        return Mnemonic.create()
    }
}
