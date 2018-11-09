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

fileprivate struct Store {
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

class WalletDetailViewController: BaseTableAdapterController {
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()

    private lazy var blockchainInteractor: WalletBlockchainWrapperInteractorInterface = inject()
    private lazy var interactor: WalletInteractorInterface = inject()
    private lazy var ammountFormatter = BalanceFormatter(asset: self.store.wallet.asset)
    
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
        loadRank()
        tableAdapter.reload(state)
        loadTransactions()
        loadBalance()
    }
    
    // MARK: - State
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationImageBar(left: LS("Wallet.Back"),
                                right: #imageLiteral(resourceName: "downArrow"),
                                title: store.wallet.name,
                                lAction: backAction,
                                rAction: detailAction),
            .empty(height: 18, background: colorProvider.settingsCellsBackround),
            .centeredImageWithUrl(url: CoinIconsUrlFormatter(name: store.wallet.asset.name,
                                                             size: .x128).url ,
                                  size: CGSize(width: 120.0, height: 120.0)),
            .empty(height: 20, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.regular.withSize(20),
                           title: store.wallet.asset.name + " " + LS("Wallet.Detail.Balance"),
                           background: colorProvider.settingsCellsBackround),
            .empty(height: 11, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.bold.withSize(24),
                           title: formattedBalance(store.balance),
                           background: colorProvider.settingsCellsBackround),
            .separator(inset: .init(top: 0, left: 61.0, bottom: 0, right: 61.0)),
            .empty(height: 7, background: colorProvider.settingsCellsBackround),
            .balanceChangingWithRank(rank: formattedCurrentRank(),
                                     balanceChanged: formateBalanceChanging(store.balanceChanging) ,
                                     perTime: "(24h)"),
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .filledSegment(titles: [LS("Wallet.Detail.Send"),
//                                    LS("Wallet.Detail.Exchange"),
                                    LS("Wallet.Detail.Receive")],
                           action: walletOperationAtIndex),
            .empty(height: 28, background: colorProvider.settingsCellsBackround)
            ] + buildTransactionState
    }
    
    // MARK: - State Builders
    private var buildTransactionState: [TableComponent] {
        guard !store.transactions.isEmpty else { return [] }
        return [.searchField(title: LS("Wallet.Detail.History.Title"),
                             icon: UIImage(),
                             action: searchTransactionAction)] + formattedTransactions
    }
    
    private var formattedTransactions: [TableComponent] {
        return self.store.transactionsByDate.map { (transactionByDate) -> [TableComponent]  in
            return formattedDateSection(date: transactionByDate.key) +
                   formattedTransactionsSection(transactionByDate.value)
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
                                     background: colorProvider.settingsBackgroud),
                .empty(height: 10, background: colorProvider.settingsBackgroud)]
    }
    
    private func formattedTransaction(_ tx: ViewTransaction) -> [TableComponent] {
        return [.transactionDetail(icon: tx.status.iconForTxType(tx.type),
                                                       title: tx.type.title ,
                                                       subtitle: tx.address,
                                                       description: tx.ammount,
                                                       action: {
                                                            (inject() as WalletRouterInterface).show(.transactionDetail(asset: self.store.wallet.asset,
                                                                                                                        txId: tx.address))
                                                       }),
                 .separator(inset: .zero)]
    }
    
    // MARK: - Network
    private func loadBalance() {
        let wallet = self.store.wallet
        let address = wallet.address
        switch wallet.asset {
        case let token as Token:
            blockchainInteractor.getTokenBalance(for: token, address: address, balance: balanceChanged)
        case let coin as Coin:
            blockchainInteractor.getCoinBalance(for: coin, address: address, balance: balanceChanged)
        default: return
        }
    }
    
    private func loadRank() {
        let rank = EssentiaStore.ranks.getRank(for: self.store.wallet.asset)
        let currentCurrency = EssentiaStore.currentUser.profile.currency
        let formatter = BalanceFormatter(currency: currentCurrency)
        let formattedRank = formatter.formattedAmmountWithCurrency(amount: rank)
        store.currentRank = formattedRank
    }
    
    private lazy var balanceChanged: (Double) -> Void = {
        let rank = EssentiaStore.ranks.getRank(for: self.store.wallet.asset) ?? 0
        let newCurrentBalance = $0 * rank
        let yesterdayBalance = self.store.wallet.yesterdayBalanceInCurrentCurrency
        self.store.balance = newCurrentBalance
        self.store.balanceChanging = self.interactor.getBalanceChanging(olderBalance: yesterdayBalance,
                                                                        newestBalance: newCurrentBalance)
        self.tableAdapter.simpleReload(self.state)
    }
    
    func getTransactionsByWallet(_ wallet: WalletInterface, transactions: @escaping ([ViewTransaction]) -> Void) {
        switch wallet.asset {
        case let token as Token:
            print("\(token.name) not done!")
        case let coin as Coin:
            switch coin {
            case .bitcoin:
                blockchainInteractor.getTxHistoryForBitcoinAddress(wallet.address) { (result) in
                    switch result {
                    case .success(let tx):
                        transactions(self.mapTransactions(tx.items))
                    case .failure(let error):
                        self.showError(error)
                    }
                }
            case .ethereum:
                blockchainInteractor.getTxHistoryForEthereumAddress(wallet.address) { (result) in
                    switch result {
                    case .success(let tx):
                        transactions(self.mapTransactions(tx.result))
                    case .failure(let error):
                        self.showError(error)
                    }
                }
            default: return
            }
        default: return
        }
    }
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var detailAction: () -> Void = {
        
    }
    
    private lazy var searchTransactionAction: () -> Void = {
        
    }
    
    private lazy var walletOperationAtIndex: (Int) -> Void = {
        switch $0 {
        case 0:
            (inject() as WalletRouterInterface).show(.enterTransactionAmmount(self.store.wallet))
//        case 1:
//            print("Show exchange")
        case 1:
            print("Show recive")
        default: return
        }
    }
    
    // MARK: - Private
    private func showError(_ error: EssentiaError) {
        (inject() as LoaderInterface).showError(message: error.localizedDescription)
    }
    
    private func mapTransactions(_ transactions: [BitcoinTransactionValue]) -> [ViewTransaction] {
        return [ViewTransaction](transactions.map({
            let ammount = $0.transactionAmmount(for: self.store.wallet.address)
            return ViewTransaction(hash: $0.txid,
                                   address: $0.txid,
                                   ammount: ammountFormatter.attributed(amount: ammount),
                                   status: $0.status,
                                   type: $0.type(for: store.wallet.address),
                                   date: TimeInterval($0.time))
        }))
    }
    
    private func mapTransactions(_ transactions: [EthereumTransactionDetail]) -> [ViewTransaction] {
        return  [ViewTransaction](transactions.map({
            let txType = $0.type(for: self.store.wallet.address)
            let address = txType == .recive ? $0.from : $0.to
            return ViewTransaction(
                hash: $0.hash,
                address: address,
                ammount: ammountFormatter.attributedHex(amount: $0.value),
                status: $0.status,
                type: $0.type(for: store.wallet.address),
                date: TimeInterval($0.timeStamp) ?? 0)
        }))
    }
    
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
        getTransactionsByWallet(store.wallet, transactions: {
            self.store.transactions = $0
            self.store.transactionsByDate = Dictionary(grouping: $0, by: { $0.stringDate })
            self.tableAdapter.simpleReload(self.state)
        })
    }
    
    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: EssentiaStore.currentUser.profile.currency)
        return formatter.formattedAmmountWithCurrency(amount: balance)
    }
    
    private func formateBalanceChanging(_ double: Double) -> String {
        let changingInProcent = interactor.getBalanceChanging(olderBalance: self.store.wallet.yesterdayBalanceInCurrentCurrency,
                                                              newestBalance: self.store.wallet.balanceInCurrentCurrency)
        return ProcentsFormatter.formattedChangePer24Hours(changingInProcent)
    }
}
