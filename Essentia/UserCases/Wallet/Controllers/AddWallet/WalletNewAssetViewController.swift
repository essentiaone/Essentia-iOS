//
//  WalletNewAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class WalletNewAssetViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
    }

    private var state: [TableComponent] {
        return [.blure(state: [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 18, background: .clear)
            ]
        )]
    }
    
    private var containerState: [TableComponent] {
        return
            [.titleWithCancel(title: LS("Wallet.NewAsset.Title"), action: backAction),
             .imageTitle(image: imageProvider.walletOptionsRename, title: LS("Wallet.NewAsset.Add.Title"), withArrow: false, action: addAssetAction),
             .imageTitle(image: imageProvider.walletOptionsExport, title: LS("Wallet.NewAsset.Import.Title"), withArrow: false, action: importAssetAction)]
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var addAssetAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
        (inject() as WalletRouterInterface).show(.addAsset)
    }
    
    private lazy var importAssetAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
        (inject() as WalletRouterInterface).show(.selectImportAsset)
    }
}
