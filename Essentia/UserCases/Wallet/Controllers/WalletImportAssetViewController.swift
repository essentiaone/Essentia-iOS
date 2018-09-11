//
//  WalletImportAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class WalletImportAssetViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Wallet.Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(bold: true, title: LS("Wallet.ImportAsset.Title")),
            .shadow(height: 16,
                    shadowColor: colorProvider.settingsShadowColor,
                    background: colorProvider.settingsBackgroud)
            ] + coins + [
            .calculatbleSpace(background: colorProvider.settingsBackgroud)
        ]
    }
    
    var coins: [TableComponent] {
        var coinsState: [TableComponent] = []
        Coin.allCases.forEach { (coin) in
            coinsState.append(.imageTitle(image: coin.icon, title: coin.name, withArrow: true, action: {
                self.importCoin(coin)
            }))
            coinsState.append(.separator(inset: .zero))
        }
        return coinsState
    }
    
    func importCoin(_ coin: Coin) {
        
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
}
