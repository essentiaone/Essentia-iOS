//
//  EnterTransactionAmmountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    var wallet: ViewWalletInterface
    var enterdValueInCurrency: String = "0"
    var enterdValueInCrypto: String = "0"
    var currentlyEdited: CurrencyType = .crypto
    let currentCurrency: FiatCurrency
    
    init(wallet: ViewWalletInterface) {
        currentCurrency = EssentiaStore.currentUser.profile.currency
        self.wallet = wallet
    }
    
    var isValidAmmount: Bool {
        return false
    }
}

class EnterTransactionAmmountViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    
    private var store: Store
    
    init(wallet: ViewWalletInterface) {
        self.store = Store(wallet: wallet)
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
    
    private var state: [TableComponent] {
        let selected = fieldsFor(type: self.store.currentlyEdited)
        let deselected = fieldsFor(type: self.store.currentlyEdited.another)
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
                                   detail: availableBalanceString, action: {}),
            .empty(height: 26, background: colorProvider.settingsCellsBackround),
            .textFieldTitleDetail(string: selected.0,
                                  font: AppFont.bold.withSize(60),
                                  color: colorProvider.titleColor,
                                  detail: formattedSelectedCurrencyField(value: selected.1),
                                  didChange: currentlyEditedFieldChanged),
            .separator(inset: .init(top: 0, left: 16, bottom: 0, right: 16)),
            .attributedTitleDetail(title: formattedDeselectedField(value:  deselected.0),
                                   detail: formattedDeselectedCurrencyField(value: deselected.1),
                                   action: disabledFieldAction),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("Wallet.Send.Continue"),
                            isEnable: store.isValidAmmount,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .keyboardInset
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
    
    func fieldsFor(type: CurrencyType) -> (String, String) {
        switch type {
        case .crypto:
            return (self.store.enterdValueInCrypto, self.store.wallet.asset.symbol)
        case .fiat:
            return (self.store.enterdValueInCurrency, self.store.currentCurrency.titleString)
        }
    }
    
    func formattedSelectedField(value: String) -> NSAttributedString {
        return NSAttributedString(string: value,
                                  attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(60),
                                               NSAttributedString.Key.foregroundColor: colorProvider.titleColor])
    }
    
    func formattedDeselectedField(value: String) -> NSAttributedString {
        return NSAttributedString(string: value,
                                  attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(40),
                                               NSAttributedString.Key.foregroundColor: colorProvider.appDefaultTextColor])
    }
    
    func formattedSelectedCurrencyField(value: String) -> NSAttributedString {
        return NSAttributedString(string: value,
                                  attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(28),
                                               NSAttributedString.Key.foregroundColor: colorProvider.appDefaultTextColor])
    }
    
    func formattedDeselectedCurrencyField(value: String) -> NSAttributedString {
        return NSAttributedString(string: value,
                                  attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(28),
                                               NSAttributedString.Key.foregroundColor: colorProvider.centeredButtonDisabledBackgroudColor])
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        self.router.pop()
    }
    
    private lazy var currentlyEditedFieldChanged: (String) -> Void = { _ in
        
    }
    
    private lazy var disabledFieldAction: () -> Void = {
        self.store.currentlyEdited = self.store.currentlyEdited.another
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var continueAction: () -> Void = {
        
    }
}
