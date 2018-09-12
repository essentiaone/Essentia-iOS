//
//  WalletInteractor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class WalletInteractor: WalletInteractorInterface {
    func isValidWallet(_ wallet: ImportedAsset) -> Bool {
        let importdAssets = EssentiaStore.currentUser.wallet.importedAssets
        let alreadyContainWallet = importdAssets.contains {
            return $0.name == wallet.name || $0.pk == wallet.pk
        }
        return !alreadyContainWallet
    }
}
