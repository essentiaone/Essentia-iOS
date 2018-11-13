//
//  WalletImportAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class WalletSelectImportAssetViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: LS("Wallet.ImportAsset.Title"),
                           lAction: backAction,
                           rAction: nil),
            .shadow(height: 16,
                    shadowColor: colorProvider.settingsShadowColor,
                    background: colorProvider.settingsBackgroud)
            ] + coins + [
            .calculatbleSpace(background: colorProvider.settingsBackgroud)
        ]
    }
    
    var coins: [TableComponent] {
        var coinsState: [TableComponent] = []
        let coins: [Coin] = (inject() as WalletInteractorInterface).getCoinsList()
        coins.forEach { (coin) in
            coinsState.append(.imageUrlTitle(imageUrl: coin.iconUrl, title: coin.name, withArrow: true, action: {
                self.importCoin(coin)
            }))
            coinsState.append(.separator(inset: .zero))
        }
        return coinsState
    }
    
    func importCoin(_ coin: Coin) {
        (inject() as WalletRouterInterface).show(.importAsset(coin))
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
}
