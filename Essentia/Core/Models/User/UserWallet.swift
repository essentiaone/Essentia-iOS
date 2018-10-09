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
    var tokenWallets: [TokenWallet] = []
    
    var isEmpty: Bool {
        return importedWallets.isEmpty && tokenWallets.isEmpty && generatedWalletsInfo.isEmpty
    }
    
    var uniqueAssets: [AssetInterface] {
        var allAssets: [AssetInterface] = []
        var unique: [AssetInterface] = []
        allAssets.append(contentsOf: importedWallets.map({ return $0.coin}))
        allAssets.append(contentsOf: generatedWalletsInfo.map({ return $0.coin }))
        allAssets.append(contentsOf: tokenWallets.map({ return $0.token }))
        for asset in allAssets {
            guard !unique.contains(where: { return $0.name == asset.name }) else { continue }
            unique.append(asset)
        }
        return unique
    }
}
