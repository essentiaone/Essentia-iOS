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
            .navigationImageBar(left: LS("Wallet.Back"),
                           right: #imageLiteral(resourceName: "downArrow"),
                           title: LS("Wallet.CreateNewAsset.Title"),
                           lAction: backAction,
                           rAction: detailAction),
            .empty(height: 11, background: colorProvider.settingsCellsBackround),
            .centeredImage(image: #imageLiteral(resourceName: "bitcoin")),
            .titleWithFont(font: AppFont.bold.withSize(32),
                           title: "Bitcoin Balance",
                           background: colorProvider.settingsCellsBackround),
            .separator(inset: .init(top: 0, left: 61.0, bottom: 0, right: 61.0)),
            .balanceChanging(status: .idle,
                             balanceChanged: "3.85%" ,
                             perTime: "(24h)",
                             action: {})
            
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
        
    }
}
