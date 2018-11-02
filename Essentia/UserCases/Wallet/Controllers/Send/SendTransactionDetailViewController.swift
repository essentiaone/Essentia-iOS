//
//  SendTransactionDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/2/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    let wallet: ViewWalletInterface
    let ammountToSend: String
    
    var isValidTransaction: Bool {
        return false
    }
    
    init(wallet: ViewWalletInterface, transactionAmmount: String) {
        self.wallet = wallet
        self.ammountToSend = transactionAmmount
    }
    
}

class SendTransactionDetailViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    
    private var store: Store
    
    init(wallet: ViewWalletInterface, ammount: String) {
        self.store = Store(wallet: wallet, transactionAmmount: ammount)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
    }
    
    /*"Wallet.Send.Amount" = "Amount";
     "Wallet.Send.To" = "To";
     "Wallet.Send.Required" = "Required";
     "Wallet.Send.Data" = "Data";
     "Wallet.Send.Optional" = "Optional";
     "Wallet.Send.Fee" = "Fee";
     "Wallet.Send.InputFee" = "Input Fee";
     "Wallet.Send.Slow" = "Slow";
     "Wallet.Send.Normal" = "Normal";
     "Wallet.Send.Fast" = "Fast";
     "Wallet.Send.Mins" = "mins";
     "Wallet.Send.hours" = "hours";
     "Wallet.Send.TransactionTime" = "Transaction time";
     "Wallet.Send.GenerateTransaction" = "GENERATE TRANSACTION";*/
    private var state: [TableComponent] {
        let ammountFormatter = BalanceFormatter(asset: store.wallet.asset)
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .attributedTitleDetail(title: NSAttributedString(string: LS("Wallet.Send.Title"),
                                                             attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(28),
                                                                          NSAttributedString.Key.strokeColor: colorProvider.appTitleColor]),
                                   detail: availableBalanceString, action: nil),
            .empty(height: 26, background: colorProvider.settingsCellsBackround),
            .titleCenteredDetail(title: LS("Wallet.Send.Amount"),
                                 detail: ammountFormatter.formattedAmmountWithCurrency(ammount: store.ammountToSend)),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("Wallet.Send.Continue"),
                            isEnable: store.isValidTransaction,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: 8, background: colorProvider.settingsCellsBackround),
            isKeyboardShown ? .keyboardInset : .empty(height: 1, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    // MARK: - Formatters
    var availableBalanceString: NSAttributedString {
        let availableString = NSMutableAttributedString()
        availableString.append(NSAttributedString(string: LS("Wallet.Send.Available") + ": ",
                                                  attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                                                               NSAttributedString.Key.foregroundColor: colorProvider.titleColor]))
        availableString.append(NSAttributedString(string: self.store.wallet.formattedBalance,
                                                  attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(15),
                                                               NSAttributedString.Key.foregroundColor: colorProvider.titleColor]))
        availableString.append(NSAttributedString(string: " "))
        availableString.append(NSAttributedString(string: self.store.wallet.asset.symbol,
                                                  attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                                                               NSAttributedString.Key.foregroundColor: colorProvider.centeredButtonDisabledBackgroudColor]))
        return availableString
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        self.view.endEditing(true)
        self.router.pop()
    }
    
    private lazy var continueAction: () -> Void = {
        
    }
}
