//
//  WalletNewAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssResources
import EssUI
import EssDI

class WalletNewAssetViewController: BaseBluredTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
    }
    
    private var state: [TableComponent] {
        return [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 18, background: .clear)
        ]
    }
    
    private var containerState: [TableComponent] {
        return
            [.titleWithCancel(title: LS("Wallet.NewAsset.Title"), action: backAction),
             .imageTitle(image: imageProvider.walletOptionsRename, title: LS("Wallet.NewAsset.Add.Title"), withArrow: false, action: addAssetAction),
             .imageTitle(image: imageProvider.walletOptionsExport, title: LS("Wallet.NewAsset.Import.Title"), withArrow: false, action: importAssetAction)]
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var addAssetAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
        (inject() as TokensServiceInterface).updateTokensIfNeeded({})
        (inject() as WalletRouterInterface).show(.addAsset(.coin))
    }
    
    private lazy var importAssetAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
        (inject() as WalletRouterInterface).show(.selectImportAsset)
    }
}
