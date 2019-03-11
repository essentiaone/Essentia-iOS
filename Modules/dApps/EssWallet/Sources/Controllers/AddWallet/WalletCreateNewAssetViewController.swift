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
import EssResources
import EssUI
import RealmSwift
import EssDI

fileprivate struct Store {
    var selectedComponent: Int = 0
    var searchString: String = ""
    var assets: [AssetInterface] = []
    var selectedAssets: [AssetInterface] = []
    var etherWalletForTokens: ViewWalletInterface?
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
        store.etherWalletForTokens = wallets.first
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
        guard store.selectedComponent != 0,
            wallets.count > 1,
            let selectedWallet = store.etherWalletForTokens else { return [] }
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
            (inject() as WalletInteractorInterface).addCoinsToWallet(self.store.selectedAssets, wallet: {_ in })
        case 1:
            guard let wallet = self.store.etherWalletForTokens else {
                (inject() as WalletInteractorInterface).addCoinsToWallet(self.store.selectedAssets, wallet: { newWallet in
                    (inject() as WalletInteractorInterface).addTokensToWallet(self.store.selectedAssets, for: newWallet)
                    (inject() as WalletRouterInterface).show(.successGeneratingAlert)
                })
                return
            }
            (inject() as WalletInteractorInterface).addTokensToWallet(self.store.selectedAssets, for: wallet)
        default: return
        }
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
            self.store.assets = self.filterTokensDueWallet()
            self.asyncReloadState()
        default: return
        }
        self.asyncReloadState()
    }
    
    private lazy var searchChangedAction: (String) -> Void = { [unowned self] in
        self.store.searchString = $0
        self.asyncReloadState()
    }
    
    private lazy var selectWalletAction: () -> Void = { [unowned self] in
        (inject() as WalletRouterInterface).show(.selectEtherWallet(wallets: self.wallets, action: { (wallet) in
            self.store.etherWalletForTokens = wallet
            self.store.assets = self.filterTokensDueWallet()
            self.asyncReloadState()
        }))
    }
    
    private var wallets: [ViewWalletInterface] {
        let generatedWallets = self.interactor.getGeneratedWallets().filter({ return $0.coin == .ethereum })
        let importedWallets = self.interactor.getImportedWallets().filter({ return $0.coin == .ethereum })
        var wallets: [ViewWalletInterface] = generatedWallets
        wallets.append(contentsOf: importedWallets)
        return wallets
    }
    
    private func filterTokensDueWallet() -> [Token] {
        guard let tokensUpdate = try? Realm().objects(TokenUpdate.self).first,
            let tokens = tokensUpdate?.tokens,
            let currentWallet = self.store.etherWalletForTokens else { return [] }
        let currentWalletAddress = currentWallet.address
        let tokenWallets = self.interactor.getTokensByWalleets()
        let alreadyAddedTokenWallets = tokenWallets[currentWalletAddress] ?? []
        let alreadyAddedTokensId = alreadyAddedTokenWallets.map({ return $0.token?.id ?? "" })
        return tokens.filter { (token) -> Bool in
            return !alreadyAddedTokensId.contains(token.id)
        }
    }
}
