//
//  UserWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

public class UserWallet: Codable {
    public var importedWallets: [ImportedWallet] = []
    public var generatedWalletsInfo: [GeneratingWalletInfo] = []
    public var tokenWallets: [TokenWallet] = []
    
    public var isEmpty: Bool {
        return importedWallets.isEmpty && tokenWallets.isEmpty && generatedWalletsInfo.isEmpty
    }
}
