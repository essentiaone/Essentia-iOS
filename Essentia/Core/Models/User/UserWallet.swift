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
}
