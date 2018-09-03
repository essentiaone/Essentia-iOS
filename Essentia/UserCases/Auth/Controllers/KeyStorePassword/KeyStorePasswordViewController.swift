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
    static var keyStoreFolder = "Keystore"
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
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var continueAction: () -> Void = {
        (inject() as LoaderInterface).show()
       self.storeMnemonic()
    }
    
    private func storeMnemonic() {
        DispatchQueue.global().async {
            let path = LocalFolderPath.final(Store.keyStoreFolder)
            do {
                let keystore = try (inject() as MnemonicServiceInterface).keyStoreFile(seed: EssentiaStore.currentUser.seed,
                                                                                       password: self.store.password)
                let url = try (inject() as LocalFilesServiceInterface).storeData(keystore,
                                                                                 to: path,
                                                                                 with: EssentiaStore.currentUser.id)
                EssentiaStore.currentUser.keystoreUrl = url
            } catch {
                (inject() as LoggerServiceInterface).log(error.localizedDescription)
            }
            self.showSuccess()
        }
    }
    
    private func showSuccess() {
        OperationQueue.main.addOperation {
            (inject() as LoaderInterface).hide()
            InfoAlertViewController.show(from: self, title: LS("KeyStoreSaved.Title"), description: LS("KeyStoreSaved.Description"), okAction: {
                EssentiaStore.currentUser.currentlyBackedUp.append(.keystore)
                (inject() as AuthRouterInterface).showNext()
            })
        }
    }
}
