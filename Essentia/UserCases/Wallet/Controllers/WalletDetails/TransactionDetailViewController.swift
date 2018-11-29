//
//  TransactionDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/28/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaBridgesApi

class TransactionDetailViewController: BaseTablePopUpController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    
    convenience init(transaction: EthereumTransactionDetail, viewTransaction: ViewTransaction) {
        self.init()
        state = containerState(viewTx: viewTransaction)
    }
    
    init() {
        super.init(position: .center)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     "Wallet.TransactionInfo.ReceivedFrom" = "Received from";
     "Wallet.TransactionInfo.Status" = "Status";
     "Wallet.TransactionInfo.ReceivedTime" = "Received Time";
     "Wallet.TransactionInfo.ReceivedRate" = "Received Rate";
     "Wallet.TransactionInfo.Confirmations" = "Confirmations";
     "Wallet.TransactionInfo.Fee" = "Fee";
     "Wallet.TransactionInfo.Data" = "Data";
     "Wallet.TransactionInfo.More" = "More";
     "Wallet.TransactionInfo.TransactionId" = "Transaction ID";
     "Wallet.TransactionInfo.GoToBlockchain" = "Go to Blockchain";
     = "CLOSE";
     */
    private func containerState(viewTx: ViewTransaction) -> [TableComponent] {
        return [.titleWithActionButton(title: LS("Wallet.TransactionInfo.Title"), icon: UIImage(named: "shareIcon")!, action: shareAction),
                .transactionDetail(icon: viewTx.status.iconForTxType(viewTx.type),
                                   title: viewTx.type.title ,
                                   subtitle: viewTx.address,
                                   description: viewTx.ammount,
                                   action: {}),
                .separator(inset: UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)),
                .separator(inset: .zero),
                .actionCenteredButton(title: LS("Wallet.TransactionInfo.Close"), action: cancelAction, backgrount: .clear)]
    }
    
    private var exportAlert: [TableComponent] {
        return [.topAlert(alertType: .info, title: LS("Wallet.Options.Export.Copied"))]
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        applyDesign()
    }
    
    private func applyDesign() {
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    private lazy var copyAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        //        UIPasteboard.general.string = self
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var shareAction: () -> Void = { [weak self] in
        
    }
    
    private lazy var cancelAction: () -> Void = { [weak self] in
        
    }
}
