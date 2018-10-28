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
    var bitcoinTransactions: [BitcoinTransactionValue] = []
    var ethereumTransactions: [EthereumTransactionDetail] = []
    var balance: Double = 0
    var balanceChanging: Double = 0
    
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
    /*
     "Wallet.Detail.Price" = "Price";
     */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdapter.reload(state)
        loadTransactions()
        loadBalance()
    }
    
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
            .balanceChanging(balanceChanged: formateBalanceChanging(store.balanceChanging) ,
                             perTime: "(24h)",
                             action: {}),
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .filledSegment(titles: [LS("Wallet.Detail.Send"),
                                    LS("Wallet.Detail.Exchange"),
                                    LS("Wallet.Detail.Receive")],
                           action: walletOperationAtIndex),
            .empty(height: 28, background: colorProvider.settingsCellsBackround)
            ] + buildTransactionState
    }
    
    private var buildTransactionState: [TableComponent] {
        guard !store.transactions.isEmpty else { return [] }
        return [.searchField(title: LS("Wallet.Detail.History.Title"),
                             icon: UIImage(),
                             action: searchTransactionAction)] + formattedTransactions
    }
    
    private var formattedTransactions: [TableComponent] {
        return self.store.transactions.compactMap({
            return [.transactionDetail(icon: $0.status.iconForTxType($0.type),
                                       title: $0.type.title ,
                                       subtitle: $0.address,
                                       description: $0.ammount,
                                       action: detailAction),
                    .separator(inset: .zero)] as [TableComponent]
        }).joined().compactMap({ return $0 }) as [TableComponent]
    }
    
    private func loadTransactions() {
        getTransactionsByWallet(store.wallet, transactions: {
            self.store.transactions = $0
            self.tableAdapter.simpleReload(self.state)
        })
    }
    
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
    
    private lazy var balanceChanged: (Double) -> Void = {
        let rank = EssentiaStore.ranks.getRank(for: self.store.wallet.asset) ?? 0
        let newCurrentBalance = $0 * rank
        let yesterdayBalance = self.store.wallet.yesterdayBalanceInCurrentCurrency
        self.store.balance = newCurrentBalance
        self.store.balanceChanging = self.interactor.getBalanceChanging(olderBalance: yesterdayBalance,
                                                                        newestBalance: newCurrentBalance)
        self.tableAdapter.simpleReload(self.state)
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
            print("Show send")
        case 1:
            print("Show exchange")
        case 2:
            print("Show recive")
        default: return
        }
    }
    
    // MARK: - Private
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
    
    private func showError(_ error: EssentiaError) {
        (inject() as LoaderInterface).showError(message: error.localizedDescription)
    }
    
    private func mapTransactions(_ transactions: [BitcoinTransactionValue]) -> [ViewTransaction] {
        return [ViewTransaction](transactions.map({
            let ammount = $0.transactionAmmount(for: self.store.wallet.address)
            return ViewTransaction(address: $0.txid,
                                   ammount: ammountFormatter.attributed(amount: ammount),
                                   status: $0.status,
                                   type: $0.type(for: store.wallet.address))
        }))
    }
    
    private func mapTransactions(_ transactions: [EthereumTransactionDetail]) -> [ViewTransaction] {
        return  [ViewTransaction](transactions.map({
            return ViewTransaction(address: $0.hash,
                                   ammount: ammountFormatter.attributedHex(amount: $0.value),
                                   status: $0.status,
                                   type: $0.type(for: store.wallet.address))
        }))
    }
    
    private func formattedBalance(_ balance: Double) -> String {
        let formatter = BalanceFormatter(currency: EssentiaStore.currentUser.profile.currency)
        return formatter.formattedAmmount(amount: balance)
    }
    
    private func formateBalanceChanging(_ double: Double) -> String {
        let changingInProcent = interactor.getBalanceChanging(olderBalance: self.store.wallet.yesterdayBalanceInCurrentCurrency,
                                                              newestBalance: self.store.wallet.balanceInCurrentCurrency)
        return ProcentsFormatter.formattedChangePer24Hours(changingInProcent)
    }
}
