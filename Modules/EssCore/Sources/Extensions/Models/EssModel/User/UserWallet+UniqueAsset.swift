//
//  UserWallet+UniqueAsset.swift
//  EssCore
//
//  Created by Pavlo Boiko on 1/9/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import EssModel

extension UserWallet {
    public var uniqueAssets: [AssetInterface] {
        var allAssets: [AssetInterface] = []
        var unique: [AssetInterface] = []
        allAssets.append(contentsOf: importedWallets.map({ return $0.coin}))
        allAssets.append(contentsOf: generatedWalletsInfo.map({ return $0.coin }))
        allAssets.append(contentsOf: tokenWallets.compactMap({ return $0.token }))
        for asset in allAssets {
            guard !unique.contains(where: { return $0.name == asset.name }) else { continue }
            unique.append(asset)
        }
        return unique
    }
    
    public func remove(wallet: ViewWalletInterface) {
        switch wallet {
        case let generated as GeneratingWalletInfo:
            realm?.delete(generated)
        case let imported as ImportedWallet:
            realm?.delete(imported)
        case let token as TokenWallet:
            realm?.delete(token)
        default: return
        }
    }
}
