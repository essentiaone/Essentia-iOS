//
//  WalletImportAssetViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Store {
    var privateKey: String = ""
    var name: String = ""
    var coin: Coin
    
    init(coin: Coin) {
        self.coin = coin
    }
    
    var isValid: Bool {
        return coin.isValidPK(privateKey)
    }
}

class WalletImportAssetViewController: BaseTableAdapterController {
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
        tableAdapter.reload(state)
    }

    private var state: [TableComponent] {
        let rawState: [TableComponent?] = [
            .empty(height: 15, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Wallet.Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(bold: true, title: LS("Wallet.Import") + " " + store.coin.name),
            .empty(height: 10, background: colorProvider.settingsBackgroud),
            .descriptionWithSize(aligment: .left,
                                               fontSize: 17,
                                               title: LS("Wallet.Import.Description"),
                                               background: colorProvider.settingsBackgroud),
            .empty(height: 8, background: colorProvider.settingsBackgroud),
            .textView(placeholder: LS("Wallet.Import.PrivateKey"),
                      text: store.privateKey,
                      endEditing: privateKeyAction),
            .separator(inset: .zero),
            .textField(placeholder: LS("Wallet.Import.Name"), text: store.name, endEditing: nameEditedAction),
            .separator(inset: .zero),
            .calculatbleSpace(background:  colorProvider.settingsBackgroud),
            .centeredButton(title: LS("Wallet.Import.ImportButton"),
                            isEnable: store.isValid,
                            action: importAction,
                            background: colorProvider.settingsBackgroud),
            .empty(height: 8, background: colorProvider.settingsBackgroud),
            isKeyboardShown ?! .keyboardInset
        ]
        return rawState.compactMap { return $0 }
    }
    
    override func keyboardDidChange() {
        super.keyboardDidChange()
        self.tableAdapter.simpleReload(state)
    }
    
    // MARK: - Actions
    private lazy var nameEditedAction: (String) -> Void = {
        self.store.name = $0
    }

    private lazy var privateKeyAction: (String) -> Void = {
        self.store.privateKey = $0
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as WalletRouterInterface).pop()
    }
    
    private lazy var importAction: () -> Void = {
        let newWallet = ImportedAsset(coin: self.store.coin, pk: self.store.privateKey, name: self.store.name)
        guard (inject() as WalletInteractorInterface).isValidWallet(newWallet) else {
            return
        }
        
    }
}
