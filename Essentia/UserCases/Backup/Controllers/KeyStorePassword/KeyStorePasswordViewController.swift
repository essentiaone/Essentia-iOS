//
//  KeyStorePasswordViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Store {
    var password: String = ""
    var isValid: Bool = false
}

class KeyStorePasswordViewController: BaseTableAdapterController {
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Store
    private var store = Store()
    let mnemonic: String
    
    // MARK: - Init
    required init(mnemonic: String) {
        self.mnemonic = mnemonic
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateState()
    }
    
    private func updateState() {
        tableAdapter.simpleReload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(title: LS("Keystore.Title")),
            .description(title: LS("Keystore.Description"), backgroud: colorProvider.settingsCellsBackround),
            .empty(height: 10.0, background: colorProvider.settingsCellsBackround),
            .password(passwordAction: passwordAction),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("SeedCopy.Continue"),
                            isEnable: store.isValid,
                            action: continueAction),
            .empty(height: 10, background: colorProvider.settingsCellsBackround),
            .keyboardInset
        ]
    }
    
    // MARK: - Actions
    private lazy var passwordAction: (Bool, String) -> Void = {
        self.store.isValid = $0
        self.store.password = $1
        self.updateState()
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as BackupRouterInterface).showPrev()
    }
    
    private lazy var continueAction: () -> Void = {
        InfoAlertViewController.show(from: self, title: LS("KeyStoreSaved.Title"), description: LS("KeyStoreSaved.Description"), okAction: {
            EssentaStore.currentUser.currentlyBackuped.append(.keystore)
            (inject() as BackupRouterInterface).showNext()
        })
    }
}
