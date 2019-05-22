//
//  WalletEnterReceiveAmmount.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/10/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

fileprivate struct Store {
    let asset: AssetInterface
    var enterdValueInCurrency: String
    var enterdValueInCrypto: String
    var currentlyEdited: CurrencyType = .crypto
    let currentCurrency: FiatCurrency
    var keyboardHeight: CGFloat = 0
    
    init(asset: AssetInterface) {
        currentCurrency = EssentiaStore.shared.currentUser.profile?.currency ?? .usd
        self.asset = asset
        enterdValueInCrypto = ""
        enterdValueInCurrency = ""
    }
    
    var isValidAmmount: Bool {
        let isNotEmpy = !enterdValueInCrypto.isEmpty
        guard let ammountInDouble = Double(enterdValueInCrypto) else { return false }
        let isNotNilNumber = ammountInDouble > 0
        return isNotEmpy && isNotNilNumber
    }
}

class WalletEnterReceiveAmmount: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var router: WalletRouterInterface = inject()
    
    private var store: Store
    private var ammountCallback: (String) -> Void
    
    init(asset: AssetInterface, ammountCallback: @escaping (String) -> Void ) {
        self.store = Store(asset: asset)
        self.ammountCallback = ammountCallback
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    override var state: [TableComponent] {
        let selected = fieldsFor(type: self.store.currentlyEdited)
        let deselected = fieldsFor(type: self.store.currentlyEdited.another)
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: "",
                           right: LS("Wallet.Receive.Enter.Done"),
                           title: "",
                           lAction: nil,
                           rAction: backAction),
            .attributedTitleDetail(title: NSAttributedString(string: LS("Wallet.Receive.Title"),
                                                             attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(28),
                                                                          NSAttributedString.Key.strokeColor: colorProvider.appTitleColor]),
                                   detail: NSAttributedString(), action: nil),
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
            .centeredButton(title: LS("Wallet.Receive.Continue"),
                            isEnable: store.isValidAmmount,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: store.keyboardHeight, background: colorProvider.settingsBackgroud)
        ]
    }
    
    // MARK: - Formatters
    
    func fieldsFor(type: CurrencyType) -> (String, String) {
        switch type {
        case .crypto:
            return (self.store.enterdValueInCrypto, self.store.asset.symbol.uppercased())
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
            let currentRank = EssentiaStore.shared.ranks.getRank(for: self.store.asset, on: store.currentCurrency),
            currentRank != 0 else {
                return ""
        }
        let ammountInCrypto = ammount / currentRank
        let formatter = BalanceFormatter(asset: store.asset)
        return formatter.formattedAmmount(amount: ammountInCrypto)
    }
    
    var cryptoInFiat: String {
        guard let ammount = Double(store.enterdValueInCrypto),
            let currentRank = EssentiaStore.shared.ranks.getRank(for: self.store.asset, on: store.currentCurrency),
            currentRank != 0 else {
                return ""
        }
        let ammountInFiat = currentRank * ammount
        let formatter = BalanceFormatter(currency: store.currentCurrency)
        return formatter.formattedAmmount(amount: ammountInFiat)
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [unowned self] in
        self.tableAdapter.endEditing(true)
        self.router.pop()
    }
    
    private lazy var currentlyEditedFieldChanged: (String) -> Void = { [unowned self] in
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
    
    private lazy var disabledFieldAction: () -> Void = { [unowned self] in
        self.tableAdapter.endEditing(true)
        self.store.currentlyEdited = self.store.currentlyEdited.another
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        self.tableAdapter.endEditing(true)
        self.router.pop()
        self.ammountCallback(self.store.enterdValueInCrypto)
    }
}
