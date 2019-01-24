//
//  UserWallet.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import RealmSwift

@objcMembers
public class UserWallet: Object {
    dynamic public var importedWallets: List<ImportedWallet> = List()
    dynamic public var generatedWalletsInfo: List<GeneratingWalletInfo> = List()
    dynamic public var tokenWallets: List<TokenWallet> = List()
    
    public var isEmpty: Bool {
        return importedWallets.isEmpty && tokenWallets.isEmpty && generatedWalletsInfo.isEmpty
    }
}
