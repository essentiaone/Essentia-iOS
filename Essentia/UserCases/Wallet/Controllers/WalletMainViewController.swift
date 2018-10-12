//
//  WalletMainViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    var tokens: [GeneratingWalletInfo : [TokenWallet]] = [:]
    var generatedWallets: [GeneratedWallet] = []
    var importedWallets: [ImportedWallet] = []
    var currentSegment: Int = 0
}

class WalletMainViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interator: WalletInteractorInterface = inject()
    private lazy var store: Store = Store()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        injectRouter()
        injectInteractor()
        loadData()
        loadBalances()
    }
    
    private func injectInteractor() {
        let injection: WalletInteractorInterface = WalletInteractor()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func injectRouter() {
        guard let navigation = navigationController else { return }
        let injection: WalletRouterInterface = WalletRouter(navigationController: navigation)
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func loadData() {
        self.store.generatedWallets = interator.getGeneratedWallets()
        self.store.importedWallets = interator.getImportedWallets()
        self.store.tokens = interator.getTokensByWalleets()
    }
    
    private var state: [TableComponent] {
        if EssentiaStore.currentUser.wallet.isEmpty {
            return emptyState
        }
        return [
        .tableWithHeight(height: 240, state: nonEmptyStaticState),
        .tableWithHeight(height: tableView.frame.height - 240, state: assetState)
        ]
    }
    
    var nonEmptyStaticState: [TableComponent] {
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .rightNavigationButton(title: LS("Wallet.Title"),
                                   image: imageProvider.bluePlus,
                                   action: addWalletAction),
            .empty(height: 20, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.regular.withSize(20),
                           title: LS("Wallet.Main.Balance.Title"),
                           background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.bold.withSize(32),
                           title: formattedBalance(interator.getBalanceInCurrentCurrency()),
                           background: colorProvider.settingsCellsBackround),
            .balanceChanging(status: .idle,
                             balanceChanged: formattedChangePer24Hours(interator.getBalanceChangePer24Hours()) ,
                             perTime: "(24h)",
                             action: updateBalanceChanginPerDay),
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .segmentControlCell(titles: [LS("Wallet.Main.Segment.First"),
                                         LS("Wallet.Main.Segment.Segment")],
                                selected: store.currentSegment,
                                action: segmentControlAction)
        ]
    }
    
    var assetState: [TableComponent] {
        switch store.currentSegment {
        case 0:
            return coinsState
        case 1:
            return tokensState
        default: return []
        }
    }
    
    var emptyState: [TableComponent] {
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .rightNavigationButton(title: "", image: imageProvider.bluePlus, action: addWalletAction),
            .title(bold: true, title: LS("Wallet.Title")),
            .empty(height: 52, background: colorProvider.settingsCellsBackround),
            .centeredImage(image: imageProvider.walletPlaceholder),
            .empty(height: 40, background: colorProvider.settingsCellsBackround),
            .descriptionWithSize(aligment: .center,
                                 fontSize: 17,
                                 title: LS("Wallet.Empty.Description"),
                                 background: colorProvider.settingsCellsBackround),
            .empty(height: 10, background: colorProvider.settingsCellsBackround),
            .smallCenteredButton(title: LS("Wallet.Empty.Add"), isEnable: true, action: addWalletAction)
        ]
    }
    
    var tokensState: [TableComponent] {
        var tokenTabState: [TableComponent] = []
        for (key, value) in store.tokens {
            tokenTabState.append(contentsOf: buildSection(title: key.name, wallets: value))
        }
        return tokenTabState
    }
    
    var coinsState: [TableComponent] {
        var coinsTypesState: [TableComponent] = []
        coinsTypesState.append(contentsOf: buildSection(title: LS("Wallet.Main.Coins.Essntia"),
                                                        wallets: store.generatedWallets))
        coinsTypesState.append(contentsOf: buildSection(title: LS("Wallet.Main.Coins.Imported"),
                                                        wallets: store.importedWallets))
        return coinsTypesState
    }
    
    func buildSection(title: String, wallets: [ViewWalletInterface]) -> [TableComponent] {
        guard !wallets.isEmpty else { return [] }
        var sectionState: [TableComponent] = []
        sectionState.append(.empty(height: 10, background: colorProvider.settingsBackgroud))
        sectionState.append(.descriptionWithSize(aligment: .left,
                                                 fontSize: 14,
                                                 title: title,
                                                 background: colorProvider.settingsBackgroud))
        sectionState.append(.empty(height: 10, background: colorProvider.settingsBackgroud))
        sectionState.append(contentsOf: buildStateForWallets(wallets))
        return sectionState
    }
    
    func buildStateForWallets(_ wallets: [ViewWalletInterface]) -> [TableComponent] {
        var assetState: [TableComponent] = []
        wallets.forEach { (wallet) in
            assetState.append(.assetBalance(imageUrl: wallet.iconUrl,
                                            title: wallet.name,
                                            value: wallet.formattedBalanceInCurrentCurrency,
                                            currencyValue: wallet.formattedBalance,
                                            action: {
                                                
            }))
            assetState.append(.separator(inset: .zero))
        }
        return assetState
    }
    
    // MARK: - Actions
    private lazy var segmentControlAction: (Int) -> Void = {
        self.store.currentSegment = $0
        self.tableAdapter.simpleReload(self.state)
        self.loadBalances()
    }
    
    private lazy var addWalletAction: () -> Void = {
        (inject() as WalletRouterInterface).show(.newAssets)
    }
    
    private lazy var updateBalanceChanginPerDay: () -> Void = {
        
    }
    
    // MARK: - Private
    
    private func loadBalances() {
        switch store.currentSegment {
        case 0:
            self.loadCoinBalances()
        case 1:
            self.loadTokenBalances()
        default: return
        }
    }
    
    private func loadCoinBalances() {
        self.store.generatedWallets.enumerated().forEach { (offset, wallet) in
            interator.getBalance(for: wallet, balance: { (balance) in
                self.store.generatedWallets[offset].lastBalance = balance
                self.tableAdapter.simpleReload(self.state)
            })
        }
        self.store.importedWallets.enumerated().forEach { (offset, wallet) in
            interator.getBalance(for: wallet, balance: { (balance) in
                self.store.importedWallets[offset].lastBalance = balance
                EssentiaStore.currentUser.wallet.importedWallets[offset].lastBalance = balance
                self.tableAdapter.simpleReload(self.state)
            })
        }
    }
    
    private func loadTokenBalances() {
        self.store.tokens.forEach { (tokenWallet) in
            tokenWallet.value.enumerated().forEach({ indexedToken in
                interator.getBalance(for: indexedToken.element, balance: { (balance) in
                    self.store.tokens[tokenWallet.key]?[indexedToken.offset].lastBalance = balance
                    self.tableAdapter.simpleReload(self.state)
                })
            })
        }
    }

    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: EssentiaStore.currentUser.profile.currency)
        return formatter.formattedAmmount(amount: balance)
    }
    
    private func formattedChangePer24Hours(_ procents: Double) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        formatter.allowsFloats = true
        return formatter.string(from: NSNumber(value: procents - 1)) ?? "0.00%"
    }
}
