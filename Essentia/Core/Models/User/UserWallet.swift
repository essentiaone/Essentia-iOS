//
//  UserWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

struct UserWallet: Codable {
    var importedWallets: [ImportedWallet] = []
    var generatedWalletsInfo: [GeneratingWalletInfo] = []
    var tokenAssets: [TokenAsset] = []
    
    var isEmpty: Bool {
        return importedWallets.isEmpty && tokenAssets.isEmpty && generatedWalletsInfo.isEmpty
    }
}
