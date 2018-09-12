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
    }

    private var state: [TableComponent] {
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Wallet.Back"), right: "", title: "", lAction: backAction, rAction: nil),
            .title(bold: true, title: LS("Wallet.NewAsset.Title")),
            .empty(height: 16, background: colorProvider.settingsBackgroud),
            .titleSubtitle(title: LS("Wallet.NewAsset.Add.Title"),
                           detail: LS("Wallet.NewAsset.Add.Subtitle"),
                           action: addAssetAction),
            .separator(inset: .zero),
            .descriptionWithSize(aligment: .left,
                                 fontSize: 13,
                                 title: LS("Wallet.NewAsset.Add.Description"),
                                 background: colorProvider.settingsBackgroud),
            .empty(height: 16, background: colorProvider.settingsBackgroud),
            .titleSubtitle(title: LS("Wallet.NewAsset.Import.Title"),
                           detail: LS("Wallet.NewAsset.Import.Subtitle"),
                           action: importAssetAction),
            .separator(inset: .zero),
            .descriptionWithSize(aligment: .left,
                                 fontSize: 13,
                                 title: LS("Wallet.NewAsset.Import.Description"),
                                 background:colorProvider.settingsBackgroud),
            .calculatbleSpace(background: colorProvider.settingsBackgroud)
        ]
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var addAssetAction: () -> Void = {
        
    }
    
    private lazy var importAssetAction: () -> Void = {
        (inject() as WalletRouterInterface).show(.selectImportAsset)
    }
}
