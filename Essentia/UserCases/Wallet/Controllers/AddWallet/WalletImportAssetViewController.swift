//
//  WalletImportAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Store {
    var privateKey: String = ""
    var name: String = ""
    var keyboardHeight: CGFloat = 0
    var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    var isValid: Bool {
        return coin.isValidPK(privateKey)
    }
}

class WalletImportAssetViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    private var store: Store
    
    init(coin: Coin) {
        store = Store(coin: coin)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        keyboardObserver.animateKeyboard = { newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    private var state: [TableComponent] {
        let rawState: [TableComponent?] = [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
            title: LS("Wallet.Import") + " " + store.coin.localizedName,
                           lAction: backAction,
                           rAction: nil),
            .empty(height: 10, background: colorProvider.settingsBackgroud),
            .descriptionWithSize(aligment: .left,
                                               fontSize: 17,
                                               title: LS("Wallet.Import.Description"),
                                               background: colorProvider.settingsBackgroud,
                                               textColor: colorProvider.appDefaultTextColor),
            .empty(height: 8, background: colorProvider.settingsBackgroud),
            .textView(placeholder: LS("Wallet.Import.PrivateKey"),
                      text: store.privateKey,
                      endEditing: privateKeyAction),
            .separator(inset: .zero),
            .textField(placeholder: LS("Wallet.Import.Name"), text: store.name, endEditing: nameEditedAction, isFirstResponder: false),
            .separator(inset: .zero),
            .calculatbleSpace(background:  colorProvider.settingsBackgroud),
            .centeredButton(title: LS("Wallet.Import.ImportButton"),
                            isEnable: store.isValid,
                            action: importAction,
                            background: colorProvider.settingsBackgroud),
            .empty(height: store.keyboardHeight, background: colorProvider.settingsBackgroud)
        ]
        return rawState.compactMap { return $0 }
    }
    
    // MARK: - Actions
    private lazy var nameEditedAction: (String) -> Void = {
        self.store.name = $0
    }

    private lazy var privateKeyAction: (String) -> Void = {
        let wasValid = self.store.isValid
        self.store.privateKey = $0
        let isValid = self.store.isValid
        if wasValid != isValid {
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var importAction: () -> Void = {
        let address = (inject() as WalletServiceInterface).generateAddress(from: self.store.privateKey, coin: self.store.coin)
        let walletName = self.store.name.isEmpty ? self.store.coin.localizedName : self.store.name
        let newWallet = ImportedWallet(address: address, coin: self.store.coin, pk: self.store.privateKey, name: walletName, lastBalance: 0)
        guard (inject() as WalletInteractorInterface).isValidWallet(newWallet) else {
            (inject() as WalletRouterInterface).show(.failImportingAlert)
            return
        }
        EssentiaStore.shared.currentUser.wallet.importedWallets.append(newWallet)
        (inject() as UserStorageServiceInterface).storeCurrentUser()
        (inject() as CurrencyRankDaemonInterface).update()
        (inject() as WalletRouterInterface).show(.succesImportingAlert)
    }
}
