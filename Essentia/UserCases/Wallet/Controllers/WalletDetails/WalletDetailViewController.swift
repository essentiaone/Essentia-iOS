//
//  WalletDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/17/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Store {
    var wallet: WalletInterface
}

class WalletDetailViewController: BaseTableAdapterController {
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var interactor: WalletInteractorInterface = inject()
    private var store: Store
    
    init(wallet: WalletInterface) {
        self.store = Store(wallet: wallet)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    /*
     "Wallet.Detail.Balance" = "Balance";
     "Wallet.Detail.Price" = "Price";
    "Wallet.Detail.History.Title" = "Transaction History";
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdapter.reload(state)
        loadTransactions()
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationImageBar(left: LS("Wallet.Back"),
                           right: #imageLiteral(resourceName: "downArrow"),
                           title: LS("Wallet.CreateNewAsset.Title"),
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
                           title: "$ 54,20013.12",
                           background: colorProvider.settingsCellsBackround),
            .separator(inset: .init(top: 0, left: 61.0, bottom: 0, right: 61.0)),
            .empty(height: 7, background: colorProvider.settingsCellsBackround),
            .balanceChanging(status: .idle,
                             balanceChanged: "3.85%" ,
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
        return [.searchField(title: LS("Wallet.Detail.History.Title"),
                icon: #imageLiteral(resourceName: "searchIcon"),
                action: searchTransactionAction)]
    }
    
    private func loadTransactions() {
        interactor.getTransactionsByWallet(store.wallet, result: {
            print($0)
        })
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
}
