//
//  WalletCreateNewAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssModel
import EssCore
import EssStore
import EssResources
import EssUI

fileprivate struct Store {
    var selectedComponent: Int = 0
    var searchString: String = ""
    var assets: [AssetInterface] = []
    var selectedAssets: [AssetInterface] = []
    var etherWalletForTokens: GeneratingWalletInfo?
}

class WalletCreateNewAssetViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var interactor: WalletInteractorInterface = inject()
    private var store: Store = Store()
    
    init(defaultCryptoType: CryptoType) {
        switch defaultCryptoType {
        case .coin:
            self.store.selectedComponent = 0
        case .token:
            self.store.selectedComponent = 1
        }
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        selectSegmentCotrolAction(self.store.selectedComponent)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideKeyboardWhenTappedAround()
    }
    
    private var state: [TableComponent] {
        return
             staticContent +
            [.tableWithCalculatableSpace(state: dynamicContent, background: colorProvider.settingsBackgroud)]
    }
    
    private var staticContent: [TableComponent] {
        return [.empty(height: 25, background: colorProvider.settingsCellsBackround),
                .navigationBar(left: LS("Back"),
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
                .empty(height: 16, background: colorProvider.settingsCellsBackround)]
    }
    
    private var dynamicContent: [TableComponent] {
        return  [.empty(height: 16, background: colorProvider.settingsBackgroud)]
                + selectWalletState + assetState +
                [.calculatbleSpace(background: colorProvider.settingsBackgroud)
        ]
    }
    
    var selectWalletState: [TableComponent] {
        guard store.selectedComponent != 0 else { return [] }
        let wallets = EssentiaStore.shared.currentUser.wallet.generatedWalletsInfo.filter({ return $0.coin == Coin.ethereum })
        guard wallets.count > 1 else { return [] }
        let selectedWallet = store.etherWalletForTokens ?? wallets.first!
        return [
            .titleSubtitleDescription(title: LS("Wallet.NewAsset.Token.SelectWallet.Title"),
                                      subtile: LS("Wallet.NewAsset.Token.SelectWallet.Subtitle"),
                                      description: selectedWallet.name,
                                      action: selectWalletAction),
            .empty(height: 4, background: colorProvider.settingsBackgroud)
        ]
    }
    
    var assetState: [TableComponent] {
        var filteredStore = self.store.assets.filter({ return $0.name.contains(self.store.searchString) })
        if filteredStore.isEmpty { filteredStore = self.store.assets }
        var coinsState: [TableComponent] = []
        filteredStore.forEach { (asset) in
            let selectedIndex = self.store.selectedAssets.index(where: { $0.name.lowercased() == asset.name.lowercased() })
            let isSelected = selectedIndex != nil
            coinsState.append(.checkImageTitle(imageUrl: asset.iconUrl, title: asset.localizedName, isSelected: isSelected, action: { [unowned self] in
                if isSelected {
                    self.store.selectedAssets.remove(at: selectedIndex!)
                } else {
                    self.store.selectedAssets.append(asset)
                }
                self.asyncReloadState()
            }))
            coinsState.append(.separator(inset: .zero))
        }
        return coinsState
    }
    
    func asyncReloadState() {
        self.tableAdapter.hardReload(state)
        self.tableAdapter.continueEditing()
    }
    
    // MARK: - Actions
    private lazy var doneAction: () -> Void = { [unowned self] in
        switch self.store.selectedComponent {
        case 0:
            (inject() as WalletInteractorInterface).addCoinsToWallet(self.store.selectedAssets)
        case 1:
            guard let wallet = self.store.etherWalletForTokens else {
                (inject() as WalletInteractorInterface).addTokensToWallet(self.store.selectedAssets)
                (inject() as WalletRouterInterface).show(.successGeneratingAlert)
                return
            }
            (inject() as WalletInteractorInterface).addTokensToWallet(self.store.selectedAssets, for: wallet)
        default: return
        }
        storeCurrentUser()
        (inject() as WalletRouterInterface).show(.successGeneratingAlert)
    }
    
    private lazy var backAction: () -> Void = { [unowned self] in
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var selectSegmentCotrolAction: (Int) -> Void = { [unowned self] in
        self.store.selectedAssets = []
        self.store.assets = []
        let interactor: WalletInteractorInterface = inject()
        self.store.selectedComponent = $0
        switch $0 {
        case 0:
            self.store.assets = interactor.getCoinsList()
        case 1:
            (inject() as LoaderInterface).show()
                interactor.getTokensList(result: { [unowned self] in
                (inject() as LoaderInterface).hide()
                self.store.assets = $0
                self.asyncReloadState()
            })
        default: return
        }
        self.asyncReloadState()
    }
    
    private lazy var searchChangedAction: (String) -> Void = { [unowned self] in
        self.store.searchString = $0
        self.asyncReloadState()
    }
    
    private lazy var selectWalletAction: () -> Void = { [unowned self] in
        let wallets = self.interactor.getGeneratedWallets().filter({ return $0.coin == .ethereum })
        (inject() as LoaderInterface).show()
        (inject() as WalletRouterInterface).show(.selectEtherWallet(wallets: wallets, action: { (wallet) in
            (inject() as LoaderInterface).hide()
            guard let generatedWallet = wallet as? GeneratingWalletInfo else { return }
            self.store.etherWalletForTokens = generatedWallet
            self.asyncReloadState()
        }))
    }
}
