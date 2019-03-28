//
//  WalletImportAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

class WalletSelectImportAssetViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: LS("Wallet.ImportAsset.Title"),
                           lAction: backAction,
                           rAction: nil),
            .empty(height: 16, background: colorProvider.settingsBackgroud)
            ] + coins + [
            .calculatbleSpace(background: colorProvider.settingsBackgroud)
        ]
    }
    
    var coins: [TableComponent] {
        var coinsState: [TableComponent] = []
        let coins: [Coin] = (inject() as WalletInteractorInterface).getCoinsList()
        coins.forEach { (coin) in
            coinsState.append(.imageUrlTitle(imageUrl: coin.iconUrl, title: coin.localizedName, withArrow: true, action: { [unowned self] in
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
