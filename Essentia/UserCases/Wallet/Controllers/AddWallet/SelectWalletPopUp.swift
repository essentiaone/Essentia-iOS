//
//  SelectWalletPopUp.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/16/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

final class SelectWalletPopUp: BaseTablePopUpController {
    init(wallets: [WalletInterface], didSelect: (WalletInterface) -> Void) {
        let state: [TableComponent] = [

        ]
        super.init(position: .bottom, state: state)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
