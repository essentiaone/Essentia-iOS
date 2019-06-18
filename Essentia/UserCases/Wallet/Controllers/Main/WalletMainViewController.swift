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
import EssDI

fileprivate struct Store {
    var tokens: [ViewWalletObject: [TokenWallet]] = [:]
    var generatedWallets: [GeneratingWalletInfo] = []
    var importedWallets: [ImportedWallet] = []
    var currentSegment: Int = 0
    var balanceChangedPer24Hours: Double = 0
    var tableHeight: CGFloat = 0
}

public class WalletMainViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interator: WalletInteractorInterface = inject()
    private lazy var blockchainInterator: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var store: Store = Store()
    
    // MARK: - Lifecycle
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload([])
        loadData()
        tableAdapter.simpleReload(state)
        showOnbordingIfNeeded()
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.store.tableHeight = tableView.frame.height
    }
    
    // MARK: - State
    private override var state: [TableComponent] {
        return staticState + dynamicState
    }
    
    private var dynamicState: [TableComponent] {
        let wallet = EssentiaStore.shared.currentUser.wallet
        switch self.store.currentSegment {
        case 0:
            let isGeneratedWalletsEmpty = wallet?.generatedWalletsInfo.isEmpty ?? true
            let isImportedWalletEmpty = wallet?.importedWallets.isEmpty ?? true
            if isImportedWalletEmpty && isGeneratedWalletsEmpty {
                return emptyState
            }
            return [.tableWithRefresh(state: coinsState(), action: refreshAction)]
        case 1:
            let isTokensEmpty = wallet?.tokenWallets.isEmpty ?? true
            if isTokensEmpty {
                return emptyState
            }
            
            return [.tableWithRefresh(state: tokensState(), action: refreshAction)]
        default: return []
        }
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
    
    private var emptyState: [TableComponent] {
        let title = self.store.currentSegment == 0 ? LS("Wallet.Empty.Description.Coin") : LS("Wallet.Empty.Description.Token")
        return [
            .empty(height: 110, background: colorProvider.settingsBackgroud),
            .descriptionWithSize(aligment: .center, fontSize: 16, title: title, background: colorProvider.settingsBackgroud, textColor: colorProvider.appDefaultTextColor),
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
        let isWalletOpened = UserDefaults.standard.bool(forKey: EssDefault.isWalletOpened.rawValue)
        if !isWalletOpened {
            UserDefaults.standard.set(true, forKey: EssDefault.isWalletOpened.rawValue)
            present(WalletWelcomeViewController(), animated: true)
        }
    }
    
    // MARK: - State builders
    func buildSection(title: String, wallets: [ViewWalletInterface]) -> [TableComponent] {
        guard !wallets.isEmpty else { return [] }
        return [
            .empty(height: 10, background: colorProvider.settingsBackgroud),
            .descriptionWithSize(aligment: .left,
                                 fontSize: 14,
                                 title: title,
                                 background: colorProvider.settingsBackgroud,
                                 textColor: colorProvider.appDefaultTextColor),
            .empty(height: 10, background: colorProvider.settingsBackgroud)] +
            buildStateForWallets(wallets)
    }
    
    func buildStateForWallets(_ wallets: [ViewWalletInterface]) -> [TableComponent] {
        return wallets |> buildAsetState |> concat
    }
    
    private func buildAsetState(_ wallet: ViewWalletInterface) -> [TableComponent] {
        return 
            [ .assetBalance(imageUrl: wallet.iconUrl,
                            title: wallet.name,
                            value: wallet.formattedBalanceInCurrentCurrencyWithSymbol,
                            currencyValue: wallet.formattedBalanceWithSymbol.uppercased(),
                            action: { [unowned self] in
                                self.showWalletDetail(for: wallet)}),
              .separator(inset: .zero)
        ]
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
//        (inject() as UserStorageServiceInterface).get({ _ in
//            self.loadBalances()
//        })
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: {
            self.tableAdapter.simpleReload(self.state)
        })
    }
    
    private lazy var refreshAction: (UIRefreshControl) -> Void = { [weak self] refresh in
        self?.hardReload(action: {
            refresh.endRefreshing()
        })
    }
    
    private lazy var addWalletAction: () -> Void = { [ weak self] in
        guard let self = self else { return }
        guard self.isConfirmed else {
            self.showConfrimAlert()
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
        (inject() as LoaderInterface).show()
        self.hardReload(action: {
            (inject() as LoaderInterface).hide()
        })
    }
    
    private func showWalletDetail(for wallet: ViewWalletInterface) {
        guard isConfirmed else {
            showConfrimAlert()
            return
        }
        (inject() as WalletRouterInterface).show(.walletDetail(wallet))
    }
    
    // MARK: - Private
    private func hardReload(action: @escaping () -> Void) {
        (inject() as CurrencyRankDaemonInterface).update { [unowned self] in
            self.reloadAllComponents(action)
        }
    }
    
    private func reloadAllComponents(_ completion: @escaping () -> Void) {
        self.loadData()
        self.loadBalances(completion)
        self.loadBalanceChangesPer24H()
        self.tableAdapter.simpleReload(self.state)
    }
    
    private func loadBalanceChangesPer24H() {
        interator.getBalanceChangePer24Hours { [unowned self] (changes) in
            self.store.balanceChangedPer24Hours = changes
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    private var isConfirmed: Bool {
        return EssentiaStore.shared.currentUser.backup?.currentlyBackup?.isConfirmed ?? false
    }
    
    private func showConfrimAlert() {
        self.present(BackupMnemonicAlert.init(leftAction: {},
                                              rightAction: {
                                                (inject() as WalletRouterInterface).show(.backupKeystore)
        }), animated: true)
    }
    
    private func loadBalances(_ completion: @escaping () -> Void) {
        switch store.currentSegment {
        case 0:
            self.loadCoinBalances(completion)
        case 1:
            self.loadTokenBalances(completion)
        default: return
        }
    }
    
    private func loadCoinBalances(_ completion: @escaping () -> Void) {
        let wallets: [CoinWalletInterface] = self.store.generatedWallets + self.store.importedWallets
        let group = DispatchGroup()
        wallets.enumerated().forEach { (arg) in
            group.enter()
            blockchainInterator.getCoinBalance(for: arg.element.coin, address: arg.element.address, balance: { [unowned self] (balance) in
                group.leave()
                (inject() as UserStorageServiceInterface).update({ _ in
                    self.store.generatedWallets[safe: arg.offset]?.lastBalance = balance
                    self.tableAdapter.simpleReload(self.state)
                })
            })
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func loadTokenBalances(_ completion: @escaping () -> Void) {
        let group = DispatchGroup()
        self.store.tokens.forEach { (tokenWallet) in
            tokenWallet.value.enumerated().forEach({ indexedToken in
                group.enter()
                let address = indexedToken.element.address
                blockchainInterator.getTokenBalance(for: indexedToken.element.token ?? Token(), address: address, balance: { [unowned self] (balance) in
                    group.leave()
                    (inject() as UserStorageServiceInterface).update({ _ in
                        self.store.tokens[tokenWallet.key]?[indexedToken.offset].lastBalance = balance
                        self.tableAdapter.simpleReload(self.state)
                    })
                })
            })
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: EssentiaStore.shared.currentUser.profile?.currency ?? .usd)
        return formatter.formattedAmmountWithCurrency(amount: balance)
    }
    
    override public var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}
