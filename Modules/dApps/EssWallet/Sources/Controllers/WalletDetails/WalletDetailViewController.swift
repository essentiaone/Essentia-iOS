//
//  WalletDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/17/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssentiaNetworkCore
import EssentiaBridgesApi
import EssCore
import HDWalletKit
import EssModel
import EssResources
import EssUI
import EssDI

fileprivate struct Store {
    var isLoadingTransactions: Bool = false
    var wallet: ViewWalletInterface
    var transactions: [ViewTransaction] = []
    var transactionsByDate: [String: [ViewTransaction]] = [:]
    var bitcoinTransactions: [BitcoinTransactionValue] = []
    var ethereumTransactions: [EthereumTransactionDetail] = []
    var balance: Double = 0
    var balanceChanging: Double = 0
    var currentRank: String = ""
    
    init(wallet: ViewWalletInterface) {
        self.wallet = wallet
    }
}

class WalletDetailViewController: BaseTableAdapterController, SwipeableNavigation {
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var blockchainInteractor: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var interactor: WalletInteractorInterface = inject()
    
    private var store: Store
    
    // MARK: - Init
    init(wallet: ViewWalletInterface) {
        self.store = Store(wallet: wallet)
        super.init()
        self.store.balance = wallet.balanceInCurrentCurrency
        self.store.balanceChanging = self.interactor.getBalanceChanging(olderBalance: wallet.yesterdayBalanceInCurrentCurrency,
                                                                        newestBalance: wallet.balanceInCurrentCurrency)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadRank()
        self.loadTransactions()
        self.loadBalance()
        tableAdapter.hardReload(state)
    }
    
    // MARK: - State
    private var state: [TableComponent] {
        return
            staticContent +
                [.tableWithCalculatableSpace(state: dynamicContent, background: .white)]
    }
    
    private var staticContent: [TableComponent] {
        return  [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationImageBar(left: LS("Back"),
                                right: imageProvider.downArrow,
                                title: store.wallet.name,
                                lAction: backAction,
                                rAction: detailAction)
        ]
    }
    
    private var dynamicContent: [TableComponent] {
        return [
            .centeredCorneredImageWithUrl(url: store.wallet.asset.iconUrl,
                                          size: CGSize(width: 120.0, height: 120.0),
                                          shadowColor: store.wallet.asset.shadowColor),
            .titleWithFont(font: AppFont.regular.withSize(20),
                           title: store.wallet.asset.localizedName + " " + LS("Wallet.Detail.Balance"),
                           background: colorProvider.settingsCellsBackround,
                           aligment: .center),
            .empty(height: 11, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.bold.withSize(24),
                           title: formattedBalance(store.balance),
                           background: colorProvider.settingsCellsBackround,
                           aligment: .center),
            .separator(inset: .init(top: 0, left: 61.0, bottom: 0, right: 61.0)),
            .empty(height: 7, background: colorProvider.settingsCellsBackround),
            .balanceChangingWithRank(rank: formattedCurrentRank(),
                                     balanceChanged: formateBalanceChanging(store.balanceChanging) ,
                                     perTime: "(24h)"),
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .filledSegment(titles: [
                LS("Wallet.Detail.Send"),
                LS("Wallet.Detail.Receive")],
                           action: walletOperationAtIndex),
            .empty(height: 28, background: colorProvider.settingsCellsBackround)
            ] + buildTransactionState +
        loaderStateIfNeeded
    }
    
    // MARK: - State Builders
    private var loaderStateIfNeeded: [TableComponent] {
        guard store.isLoadingTransactions else { return [] }
        return [.empty(height: 28, background: colorProvider.settingsCellsBackround),
                .loader]
    }
    
    private var buildTransactionState: [TableComponent] {
        guard !store.transactions.isEmpty else { return [] }
        return [.searchField(title: LS("Wallet.Detail.History.Title"),
                             icon: UIImage(),
                             action: searchTransactionAction)] + formattedTransactions
    }
    
    // Refactor?
    private var formattedTransactions: [TableComponent] {
        let txByDate = self.store.transactionsByDate
        let keys = txByDate.keys.sorted { (lhs, rhs) -> Bool in
            let dateFormatter = DateFormatter(formate: DateFormat.dayMonth)
            let lhsDate = dateFormatter.date(from: lhs) ?? Date()
            let rhsDate = dateFormatter.date(from: rhs) ?? Date()
            return lhsDate > rhsDate
        }
        return keys.map { (key) -> [TableComponent]  in
            return formattedDateSection(date: key) +
                formattedTransactionsSection(txByDate[key] ?? [])
            }.reduce([], + )
    }
    
    private func formattedTransactionsSection(_ transactions: [ViewTransaction]) -> [TableComponent] {
        return transactions.map {
            return formattedTransaction($0)
            }.reduce([], + )
    }
    
    private func formattedDateSection(date: String) -> [TableComponent] {
        return [.empty(height: 10, background: colorProvider.settingsBackgroud),
                .descriptionWithSize(aligment: .left,
                                     fontSize: 14,
                                     title: date,
                                     background: colorProvider.settingsBackgroud,
                                     textColor: colorProvider.appDefaultTextColor),
                .empty(height: 10, background: colorProvider.settingsBackgroud)]
    }
    
    private func formattedTransaction(_ tx: ViewTransaction) -> [TableComponent] {
        return [.transactionDetail(icon: tx.status.iconForTxType(tx.type),
                                   title: tx.type.title ,
                                   subtitle: tx.address,
                                   description: tx.ammount,
                                   action: {
                                    (inject() as WalletRouterInterface).show(.transactionDetail(asset: self.store.wallet.asset,
                                                                                                txId: tx.hash))
        }),
                .separator(inset: .zero)]
    }
    
    // MARK: - Network
    private func loadBalance() {
        let wallet = self.store.wallet
        (inject() as UserStorageServiceInterface).get { _ in
            let address = wallet.address
            print(wallet.asset)
            switch wallet.asset {
            case let token as Token:
                self.blockchainInteractor.getTokenBalance(for: token, address: address, balance: self.balanceChanged)
            case let coin as EssModel.Coin:
                self.blockchainInteractor.getCoinBalance(for: coin, address: address, balance: self.balanceChanged)
            default: return
            }
        }
    }
    
    private func loadRank() {
        (inject() as UserStorageServiceInterface).update { (user) in
            let currentCurrency = user.profile?.currency ?? .usd
            let rank = EssentiaStore.shared.ranks.getRank(for: self.store.wallet.asset, on: currentCurrency)
            let formatter = BalanceFormatter(currency: currentCurrency)
            let formattedRank = formatter.formattedAmmountWithCurrency(amount: rank)
            self.store.currentRank = formattedRank
        }
    }
    
    private lazy var balanceChanged: (Double) -> Void = { balance in
        (inject() as UserStorageServiceInterface).update { (user) in
            let currentCurrency = user.profile?.currency ?? .usd
            let rank = EssentiaStore.shared.ranks.getRank(for: self.store.wallet.asset, on: currentCurrency) ?? 0
            let newCurrentBalance = balance * rank
            let yesterdayBalance = self.store.wallet.yesterdayBalanceInCurrentCurrency
            self.store.balance = newCurrentBalance
            self.store.balanceChanging = self.interactor.getBalanceChanging(olderBalance: yesterdayBalance,
                                                                            newestBalance: newCurrentBalance)
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var detailAction: () -> Void = { [unowned self] in
        (inject() as WalletRouterInterface).show(.walletOptions(self.store.wallet))
    }
    
    private lazy var searchTransactionAction: () -> Void = {
        
    }
    
    private lazy var walletOperationAtIndex: (Int) -> Void = { [unowned self] in
        switch $0 {
        case 0:
            (inject() as WalletRouterInterface).show(.enterTransactionAmmount(self.store.wallet))
        case 1:
            (inject() as WalletRouterInterface).show(.receive(self.store.wallet))
        default: return
        }
    }
    
    // MARK: - Private
    private func formattedCurrentRank() -> NSAttributedString {
        let formatted = NSMutableAttributedString(string: LS("Wallet.Detail.Price"),
                                                  attributes: [NSAttributedString.Key.foregroundColor:
                                                    colorProvider.appDefaultTextColor])
        formatted.append(NSAttributedString(string: store.currentRank,
                                            attributes: [NSAttributedString.Key.foregroundColor:
                                                colorProvider.appTitleColor]))
        formatted.addAttributes([NSAttributedString.Key.font: AppFont.medium.withSize(17)],
                                range: .init(location: 0, length: formatted.length))
        return formatted
    }
    
    private func loadTransactions() {
        self.store.isLoadingTransactions = true
        (inject() as WalletBlockchainWrapperInteractorInterface).getTransactionsByWallet(store.wallet, transactions: { [unowned self] in
            self.store.transactions = $0
            self.store.transactionsByDate = Dictionary(grouping: $0, by: { $0.stringDate })
            self.store.isLoadingTransactions = false
            self.tableAdapter.simpleReload(self.state)
        })
    }
    
    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: EssentiaStore.shared.currentUser.profile?.currency ?? .usd)
        return formatter.formattedAmmountWithCurrency(amount: balance)
    }
    
    private func formateBalanceChanging(_ double: Double) -> String {
        let changingInProcent = interactor.getBalanceChanging(olderBalance: self.store.wallet.yesterdayBalanceInCurrentCurrency,
                                                              newestBalance: self.store.wallet.balanceInCurrentCurrency)
        return ProcentsFormatter.formattedChangePer24Hours(changingInProcent)
    }
}
