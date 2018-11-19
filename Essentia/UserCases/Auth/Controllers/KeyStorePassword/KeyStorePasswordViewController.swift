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
    var repeatPass: String = ""
    var isValid: Bool = false
    var isValidRepeate: Bool = false
    var isBothValid: Bool {
        return isValid && isValidRepeate && password == repeatPass
    }
    static var keyStoreFolder = "Keystore"
}

class KeyStorePasswordViewController: BaseTableAdapterController, UIDocumentBrowserViewControllerDelegate {
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Store
    private var store = Store()
    private var keystore: Data?
    let authType: AuthType
    
    // MARK: - Init
    required init(_ auth: AuthType) {
        authType = auth
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if authType == .login && keystore == nil {
            showFilePicker()
            return
        }
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
            .title(bold: true, title: LS("Keystore.Title")),
            .description(title: LS("Keystore.Description"), backgroud: colorProvider.settingsCellsBackround),
            .empty(height: 10.0, background: colorProvider.settingsCellsBackround),
            .password(title: LS("Keystore.PasswordField.Title"), withProgress: false, passwordAction: passwordAction),
            .password(title: LS("Keystore.PasswordField.Repeat"), withProgress: true, passwordAction: repeatAction),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("SeedCopy.Continue"),
                            isEnable: store.isBothValid,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: 50, background: colorProvider.settingsCellsBackround),
            .keyboardInset
        ]
    }
    
    // MARK: - Actions
    private lazy var passwordAction: (Bool, String) -> Void = {
        self.store.isValid = $0
        self.store.password = $1
        self.updateState()
    }
    
    private lazy var repeatAction: (Bool, String) -> Void = {
        self.store.isValidRepeate = $0
        self.store.repeatPass = $1
        self.updateState()
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var continueAction: () -> Void = {
        switch self.authType {
        case .backup:
            (inject() as LoaderInterface).show()
            self.storeKeystore()
        case .login:
            self.decodeKeystore()
        }
    }
    
    private func decodeKeystore() {
        guard let data = self.keystore else { return }
        let seed = (inject() as MnemonicServiceInterface).mnemonic(from: data, password: self.store.password)
        if let seed = seed {
            let user = User(seed: seed)
            EssentiaStore.shared.setUser(user)
        }
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private func showFilePicker() {
        let fileBrowser = UIDocumentBrowserViewController(forOpeningFilesWithContentTypes: ["public.plain-text"])
        fileBrowser.allowsPickingMultipleItems = false
        fileBrowser.delegate = self
        present(fileBrowser, animated: true)
    }
    
    private func storeKeystore() {
        guard let mneminic = EssentiaStore.shared.currentUser.mnemonic else { return }
        DispatchQueue.global().async {
            let path = LocalFolderPath.final(Store.keyStoreFolder)
            do {
                let keystore = try (inject() as MnemonicServiceInterface).keyStoreFile(mnemonic: mneminic,
                                                                                       password: self.store.password)
                let url = try (inject() as LocalFilesServiceInterface).storeData(keystore,
                                                                                 to: path,
                                                                                 with: "\(EssentiaStore.shared.currentUser.id).txt")
                EssentiaStore.shared.currentUser.backup.keystoreUrl = url
                (inject() as UserStorageServiceInterface).storeCurrentUser()
            } catch {
                (inject() as LoggerServiceInterface).log(error.localizedDescription)
            }
            self.showSuccess()
        }
    }
    
    private func showSuccess() {
        OperationQueue.main.addOperation {
            (inject() as LoaderInterface).hide()
            let alert = KeystoreSavedAlert(okAction: {
                EssentiaStore.shared.currentUser.backup.currentlyBackedUp.append(.keystore)
                (inject() as UserStorageServiceInterface).storeCurrentUser()
                (inject() as AuthRouterInterface).showNext()
            })
            self.present(alert, animated: true)
        }
    }
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentURLs documentURLs: [URL]) {
        dismiss(animated: true)
        guard let url = documentURLs.first else { return }
        if url.startAccessingSecurityScopedResource() {
            NSFileCoordinator().coordinate(readingItemAt: url, options: .withoutChanges, error: nil) { (newUrl) in
                self.keystore = try? Data(contentsOf: newUrl)
            }
            url.stopAccessingSecurityScopedResource()
        }
    }
}
