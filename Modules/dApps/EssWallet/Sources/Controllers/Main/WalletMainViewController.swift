//
//  WalletMainViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssCore
import EssResources
import EssUI
import EssStore

fileprivate struct Store {
    var tokens: [GeneratingWalletInfo: [TokenWallet]] = [:]
    var generatedWallets: [GeneratingWalletInfo] = []
    var importedWallets: [ImportedWallet] = []
    var currentSegment: Int = 0
    var balanceChangedPer24Hours: Double = 0
    var tableHeight: CGFloat = 0
    static var isWalletOpened = "isWalletOpened"
    
}

public class WalletMainViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interator: WalletInteractorInterface = inject()
    private lazy var blockchainInterator: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var store: Store = Store()
    
    // MARK: - Lifecycle
    override public func viewDidLoad() {
        super.viewDidLoad()
        (inject() as LoaderInterface).show()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hardReload()
        showOnbordingIfNeeded()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.store.tableHeight = tableView.frame.height
    }
    
    // MARK: - State
    private func state() -> [TableComponent] {
        return staticState + dynamicState
    }
    
    private var dynamicState: [TableComponent] {
        let showWallets = !EssentiaStore.shared.currentUser.wallet.isEmpty
        if showWallets {
            return [.tableWithCalculatableSpace(state: assetState, background: .white)]
        }
        return emptyState
    }
    
    private var staticState: [TableComponent] {
        let procents = ProcentsFormatter.formattedChangePer24Hours(store.balanceChangedPer24Hours)
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .rightNavigationButton(title: LS("Wallet.Title"),
                                   image: imageProvider.bluePlus,
                                   action: addWalletAction),
            .empty(height: 20, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.regular.withSize(20),
                           title: LS("Wallet.Main.Balance.Title"),
                           background: colorProvider.settingsCellsBackround,
                           aligment: .center),
            .titleWithFont(font: AppFont.bold.withSize(32),
                           title: formattedBalance(interator.getTotalBalanceInCurrentCurrency()),
                           background: colorProvider.settingsCellsBackround,
                           aligment: .center),
            .balanceChanging(balanceChanged: procents,
                             perTime: "(24h)",
                             action: updateBalanceChanginPerDay),
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .customSegmentControlCell(titles: [LS("Wallet.Main.Segment.First"),
                                               LS("Wallet.Main.Segment.Segment")],
                                      selected: store.currentSegment,
                                      action: segmentControlAction)
        ]
    }
    
    private var assetState: [TableComponent] {
        switch store.currentSegment {
        case 0:
            return coinsState()
        case 1:
            return tokensState()
        default: return []
        }
    }
    
    private var emptyState: [TableComponent] {
        return [
            .empty(height: 110, background: colorProvider.settingsBackgroud),
            .descriptionWithSize(aligment: .center, fontSize: 16, title: LS("Wallet.Empty.Description"), background: colorProvider.settingsBackgroud, textColor: colorProvider.appDefaultTextColor),
            .calculatbleSpace(background: colorProvider.settingsBackgroud),
            .smallCenteredButton(title: LS("Wallet.Empty.Add"), isEnable: true, action: addWalletAction, background: colorProvider.settingsBackgroud),
            .empty(height: 16, background: colorProvider.settingsBackgroud)
        ]
    }
    
    private func tokensState() -> [TableComponent] {
        var tokenTabState: [TableComponent] = []
        for (key, value) in store.tokens {
            tokenTabState.append(contentsOf: buildSection(title: key.name, wallets: value))
        }
        return tokenTabState
    }
    
    private func coinsState() -> [TableComponent] {
        var coinsTypesState: [TableComponent] = []
        coinsTypesState.append(contentsOf: buildSection(title: LS("Wallet.Main.Coins.Essntia"),
                                                        wallets: store.generatedWallets))
        coinsTypesState.append(contentsOf: buildSection(title: LS("Wallet.Main.Coins.Imported"),
                                                        wallets: store.importedWallets))
        return coinsTypesState
    }
    
    private func showOnbordingIfNeeded() {
        let isWalletOpened = UserDefaults.standard.bool(forKey: Store.isWalletOpened)
        if !isWalletOpened {
            UserDefaults.standard.set(true, forKey: Store.isWalletOpened)
            storeCurrentUser()
            present(WalletWelcomeViewController(), animated: true)
        }
    }
    
    // MARK: - State builders
    func buildSection(title: String, wallets: [ViewWalletInterface]) -> [TableComponent] {
        guard !wallets.isEmpty else { return [] }
        var sectionState: [TableComponent] = []
        sectionState.append(.empty(height: 10, background: colorProvider.settingsBackgroud))
        sectionState.append(.descriptionWithSize(aligment: .left,
                                                 fontSize: 14,
                                                 title: title,
                                                 background: colorProvider.settingsBackgroud,
                                                 textColor: colorProvider.appDefaultTextColor))
        sectionState.append(.empty(height: 10, background: colorProvider.settingsBackgroud))
        sectionState.append(contentsOf: buildStateForWallets(wallets))
        return sectionState
    }
    
    func buildStateForWallets(_ wallets: [ViewWalletInterface]) -> [TableComponent] {
        var assetState: [TableComponent] = []
        wallets.forEach { (wallet) in
            assetState.append(
                .assetBalance(imageUrl: wallet.iconUrl,
                              title: wallet.name,
                              value: wallet.formattedBalanceInCurrentCurrencyWithSymbol,
                              currencyValue: wallet.formattedBalanceWithSymbol.uppercased(),
                              action: { [unowned self] in
                                self.showWalletDetail(for: wallet)
                                
                })
            )
            assetState.append(.separator(inset: .zero))
        }
        return assetState
    }
    
    // MARK: - Cash
    private func loadData() {
        self.store.generatedWallets = interator.getGeneratedWallets()
        self.store.importedWallets = interator.getImportedWallets()
        self.store.tokens = interator.getTokensByWalleets()
    }
    
    // MARK: - Actions
    private lazy var segmentControlAction: (Int) -> Void = { [unowned self] in
        self.store.currentSegment = $0
        DispatchQueue.global().async {
            self.loadBalances()
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            self.tableAdapter.simpleReload(self.state())
        })
    }
    
    private lazy var addWalletAction: () -> Void = {
        guard !EssentiaStore.shared.currentUser.backup.currentlyBackedUp.isEmpty else {
            self.present(BackupMnemonicAlert.init(leftAction: {},
                                                  rightAction: {
                                                    (inject() as WalletRouterInterface).show(.backupKeystore)
            }), animated: true)
            return
        }
        switch self.store.currentSegment {
        case 0:
            (inject() as WalletRouterInterface).show(.newAssets)
        case 1:
            (inject() as WalletRouterInterface).show(.addAsset(.token))
        default: return
        }
    }
    
    private lazy var updateBalanceChanginPerDay: () -> Void = { [unowned self] in
        self.hardReload()
    }
    
    private func showWalletDetail(for wallet: ViewWalletInterface) {
        (inject() as WalletRouterInterface).show(.walletDetail(wallet))
    }
    
    // MARK: - Private
    private func hardReload() {
        (inject() as LoaderInterface).show()
        (inject() as CurrencyRankDaemonInterface).update { [unowned self] in
            self.reloadAllComponents()
            (inject() as LoaderInterface).hide()
        }
    }
    
    private func reloadAllComponents() {
        self.loadData()
        self.loadBalances()
        self.loadBalanceChangesPer24H()
        self.tableAdapter.simpleReload(self.state())
    }
    
    private func loadBalanceChangesPer24H() {
        interator.getBalanceChangePer24Hours { [unowned self] (changes) in
            self.store.balanceChangedPer24Hours = changes
            self.tableAdapter.simpleReload(self.state())
        }
    }
    
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
        let seed = EssentiaStore.shared.currentCredentials.seed
        self.store.generatedWallets.enumerated().forEach { (arg) in
            let address = arg.element.address(withSeed: seed)
            blockchainInterator.getCoinBalance(for: arg.element.coin, address: address, balance: { [unowned self] (balance) in
                self.store.generatedWallets[safe: arg.offset]?.lastBalance = balance
                self.tableAdapter.simpleReload(self.state())
            })
        }
        self.store.importedWallets.enumerated().forEach { (arg) in
            blockchainInterator.getCoinBalance(for: arg.element.coin, address: arg.element.address, balance: { [unowned self] (balance) in
                self.store.importedWallets[safe: arg.offset]?.lastBalance = balance
                EssentiaStore.shared.currentUser.wallet.importedWallets[safe: arg.offset]?.lastBalance = balance
                storeCurrentUser()
                self.tableAdapter.simpleReload(self.state())
            })
        }
    }
    
    private func loadTokenBalances() {
        let seed = EssentiaStore.shared.currentCredentials.seed
        self.store.tokens.forEach { (tokenWallet) in
            tokenWallet.value.enumerated().forEach({ indexedToken in
                let address = indexedToken.element.address(withSeed: seed)
                blockchainInterator.getTokenBalance(for: indexedToken.element.token, address: address, balance: { [unowned self] (balance) in
                    self.store.tokens[tokenWallet.key]?[indexedToken.offset].lastBalance = balance
                    self.tableAdapter.simpleReload(self.state())
                })
            })
        }
    }
    
    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: EssentiaStore.shared.currentUser.profile.currency)
        return formatter.formattedAmmountWithCurrency(amount: balance)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
