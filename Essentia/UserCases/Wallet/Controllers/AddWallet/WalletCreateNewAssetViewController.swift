//
//  WalletCreateNewAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    var selectedComponent: Int = 0
    var searchString: String = ""
    var assets: [AssetInterface] = []
    var selectedAssets: [AssetInterface] = []
}

class WalletCreateNewAssetViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private var store: Store = Store()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        selectSegmentCotrolAction(0)
        hideKeyboardWhenTappedAround()
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Wallet.Back"),
                           right: LS("Wallet.CreateNewAsset.Done"),
                           title: LS("Wallet.CreateNewAsset.Title"),
                           lAction: backAction,
                           rAction: doneAction),
            .empty(height: 11, background: colorProvider.settingsCellsBackround),
            .segmentControlCell(titles: [LS("Wallet.CreateNewAsset.Switch.Coins"),
                                         LS("Wallet.CreateNewAsset.Switch.Tokens")],
                                selected: store.selectedComponent, action: selectSegmentCotrolAction),
            .empty(height: 16, background: colorProvider.settingsCellsBackround),
            .search(title: store.searchString,
                    placeholder: LS("Wallet.CreateNewAsset.SearchPlaceholder"),
                    tint: colorProvider.settingsCellsBackround,
                    backgroud: colorProvider.settingsBackgroud,
                    didChange: searchChangedAction),
            .empty(height: 16, background: colorProvider.settingsCellsBackround),
            .empty(height: 16, background: colorProvider.settingsBackgroud)
            ] + assetState + [
            .calculatbleSpace(background: colorProvider.settingsBackgroud)
        ]
    }
    
    var assetState: [TableComponent] {
        var filteredStore = self.store.assets.filter({ return $0.name.contains(self.store.searchString) })
        if filteredStore.isEmpty { filteredStore = self.store.assets }
        var coinsState: [TableComponent] = []
        filteredStore.forEach { (asset) in
            let selectedIndex = self.store.selectedAssets.index(where: { $0.name.lowercased() == asset.name.lowercased() })
            let isSelected = selectedIndex != nil
            coinsState.append(.checkImageTitle(image: asset.icon, title: asset.name, isSelected: isSelected, action: {
                if isSelected {
                    self.store.selectedAssets.remove(at: selectedIndex!)
                } else {
                    self.store.selectedAssets.append(asset)
                }
                self.tableAdapter.simpleReload(self.state)
            }))
            coinsState.append(.separator(inset: .zero))
        }
        return coinsState
    }
    
    // MARK: - Actions
    private lazy var doneAction: () -> Void = {
        switch self.store.selectedComponent {
        case 0:
            (inject() as WalletInteractorInterface).addCoinsToWallet(self.store.selectedAssets)
        case 1:
            (inject() as WalletInteractorInterface).addTokensToWallet(self.store.selectedAssets)
        default: return
        }
        (inject() as WalletRouterInterface).show(.succesImportingAlert)
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var selectSegmentCotrolAction: (Int) -> Void = {
        self.store.selectedAssets = []
        let interactor: WalletInteractorInterface = inject()
        self.store.selectedComponent = $0
        switch $0 {
        case 0:
            self.store.assets = interactor.getCoinsList()
            self.tableAdapter.simpleReload(self.state)
        case 1:
            interactor.getTokensList(result: {
                self.store.assets = $0
                self.tableAdapter.simpleReload(self.state)
            })
        default: return
        }
    }
    
    private lazy var searchChangedAction: (String) -> Void = {
        self.store.searchString = $0
        self.tableAdapter.simpleReload(self.state)
    }
}
