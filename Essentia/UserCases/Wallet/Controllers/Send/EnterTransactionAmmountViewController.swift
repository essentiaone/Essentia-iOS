//
//  EnterTransactionAmmountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    let wallet: ViewWalletInterface
    var enterdValueInCurrency: String
    var enterdValueInCrypto: String
    var currentlyEdited: CurrencyType = .crypto
    let currentCurrency: FiatCurrency
    
    init(wallet: ViewWalletInterface) {
        currentCurrency = EssentiaStore.currentUser.profile.currency
        self.wallet = wallet
        enterdValueInCrypto = wallet.formattedBalance
        enterdValueInCurrency = wallet.formattedBalanceInCurrentCurrency
    }
    
    var isValidAmmount: Bool {
        guard let entered = Double(enterdValueInCrypto) else { return false }
        return entered <= (wallet.lastBalance ?? 0)
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
                                   detail: availableBalanceString, action: nil),
            .empty(height: 26, background: colorProvider.settingsCellsBackround),
            .textFieldTitleDetail(string: selected.0,
                                  font: AppFont.bold.withSize(60),
                                  color: colorProvider.titleColor,
                                  detail: formattedSelectedCurrencyField(value: selected.1),
                                  didChange: currentlyEditedFieldChanged),
            .separator(inset: .init(top: 0, left: 16, bottom: 0, right: 16)),
            .attributedTitleDetail(title: formattedDeselectedField(value: deselected.0),
                                   detail: formattedDeselectedCurrencyField(value: deselected.1),
                                   action: disabledFieldAction),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("Wallet.Send.Continue"),
                            isEnable: store.isValidAmmount,
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
    
    var fiatAmmountInCrypto: String {
        guard let ammount = Double(store.enterdValueInCurrency),
            let currentRank = EssentiaStore.ranks.getRank(for: self.store.wallet.asset),
            currentRank != 0 else {
                return ""
        }
        let ammountInCrypto = ammount / currentRank
        let formatter = BalanceFormatter(asset: store.wallet.asset)
        return formatter.formattedAmmount(amount: ammountInCrypto)
    }
    
    var cryptoInFiat: String {
        guard let ammount = Double(store.enterdValueInCrypto),
            let currentRank = EssentiaStore.ranks.getRank(for: self.store.wallet.asset),
            currentRank != 0 else {
                return ""
        }
        let ammountInFiat = currentRank * ammount
        let formatter = BalanceFormatter(currency: store.currentCurrency)
        return formatter.formattedAmmount(amount: ammountInFiat)
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.view.endEditing(true)
        self.router.pop()
    }
    
    private lazy var currentlyEditedFieldChanged: (String) -> Void = {  [weak self] in
        guard let `self` = self else { return }
        switch self.store.currentlyEdited {
        case .fiat:
            self.store.enterdValueInCurrency = $0
            self.store.enterdValueInCrypto = self.fiatAmmountInCrypto
        case .crypto:
            self.store.enterdValueInCrypto = $0
            self.store.enterdValueInCurrency = self.cryptoInFiat
            
        }
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var disabledFieldAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.tableView.endEditing(true)
        self.store.currentlyEdited = self.store.currentlyEdited.another
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var continueAction: () -> Void = {
        self.tableView.endEditing(true)
        self.router.show(.sendTransactionDetail(self.store.wallet, self.store.enterdValueInCrypto))
    }
    
    // MARK: - Keyboard
    override func keyboardDidChange() {
        self.tableAdapter.simpleReload(state)
    }
}
