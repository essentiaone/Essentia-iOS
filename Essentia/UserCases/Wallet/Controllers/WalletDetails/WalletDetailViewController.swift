//
//  WalletDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/17/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    
}

class WalletDetailViewController: BaseTableAdapterController {
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var interactor: WalletInteractorInterface = inject()
    private var store: Store = Store()
    
    // MARK: - Lifecycle
    
    
    /*
     "Wallet.Detail.Balance" = "Balance";
     "Wallet.Detail.Price" = "Price";
     "Wallet.Detail.Send" = "SEND";
     "Wallet.Detail.Exchange" = "EXCHANGE";
     "Wallet.Detail.Receive" = "RECEIVE";
     "Wallet.Detail.History.Title" = "Transaction History";
     "Wallet.Detail.History.ReceivedFrom" = "Received from";
     "Wallet.Detail.History.Exchanged" = "Exchanged to";
     "Wallet.Detail.History.SendTo" = "Send to";
*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdapter.reload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Wallet.Back"),
                           right: LS("Wallet.CreateNewAsset.Done"),
                           title: LS("Wallet.CreateNewAsset.Title"),
                           lAction: backAction,
                           rAction: detailAction),
            .empty(height: 11, background: colorProvider.settingsCellsBackround)
        ] + buildTransactionState
    }
    
    private var buildTransactionState: [TableComponent] {
        return []
    }
    
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var detailAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
}
