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
    let authType: AuthType
    var keyboardHeight: CGFloat = 0
    
    var isBothValid: Bool {
        if authType == .login {
            return !password.isEmpty
        }
        return isValid && isValidRepeate && password == repeatPass
    }
    
    init(authType: AuthType) {
        self.authType = authType
    }
    static var keyStoreFolder = "Keystore"
}

class KeyStorePasswordViewController: BaseTableAdapterController, UIDocumentPickerDelegate, SwipeableNavigation {
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Store
    private var store: Store
    private var keystore: Data?
    private var isPickerShown: Bool = false
    
    // MARK: - Init
    required init(_ auth: AuthType) {
        store = Store(authType: auth)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if store.authType == .login && keystore == nil && !isPickerShown {
            showFilePicker()
            return
        }
        updateState()
        keyboardObserver.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
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
            .empty(height: 10.0, background: colorProvider.settingsCellsBackround)]
            + passwordState +
            [.calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("SeedCopy.Continue"),
                            isEnable: store.isBothValid,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: store.keyboardHeight, background: colorProvider.settingsBackgroud)
        ]
    }
    
    private var passwordState: [TableComponent] {
        switch store.authType {
        case .login:
            return [.password(title: LS("Keystore.PasswordField.Title"), withProgress: true, passwordAction: passwordAction)]
        case .backup:
            return [.password(title: LS("Keystore.PasswordField.Title"), withProgress: false, passwordAction: passwordAction),
                    .password(title: LS("Keystore.PasswordField.Repeat"), withProgress: true, passwordAction: repeatAction)]
        }
    }
    
    // MARK: - Actions
    private lazy var passwordAction: (Bool, String) -> Void = { [unowned self] in
        self.store.isValid = $0
        self.store.password = $1
        self.updateState()
    }
    
    private lazy var repeatAction: (Bool, String) -> Void = { [unowned self] in
        self.store.isValidRepeate = $0
        self.store.repeatPass = $1
        self.updateState()
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        switch self.store.authType {
        case .backup:
            (inject() as LoaderInterface).show()
            self.storeKeystore()
        case .login:
            self.decodeKeystore()
        }
    }
    
    private func decodeKeystore() {
        guard let data = self.keystore else { return }
        if let mnemonic = (inject() as MnemonicServiceInterface).mnemonic(from: data, password: self.store.password) {
            let user = User(mnemonic: mnemonic)
            user.backup.currentlyBackedUp = [.keystore]
            do {
                try EssentiaStore.shared.setUser(user, password: User.defaultPassword)
            } catch {
                (inject() as LoaderInterface).showError(error)
            }
        }
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private func showFilePicker() {
        let fileBrowser = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .open)
        fileBrowser.delegate = self
        isPickerShown = true
        present(fileBrowser, animated: true)
    }
    
    private func storeKeystore() {
        guard let mneminic = EssentiaStore.shared.currentCredentials.mnemonic else { return }
        DispatchQueue.global().async { [unowned self] in
            let path = LocalFolderPath.final(Store.keyStoreFolder)
            do {
                let keystore = try (inject() as MnemonicServiceInterface).keyStoreFile(mnemonic: mneminic,
                                                                                       password: self.store.password)
                let url = try (inject() as LocalFilesServiceInterface).storeData(keystore,
                                                                                 to: path,
                                                                                 with: "\(EssentiaStore.shared.currentUser.dislayName)")
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
            self.encodeCurrentUser()
            let alert = KeystoreSavedAlert(okAction: {
                EssentiaStore.shared.currentUser.backup.currentlyBackedUp.insert(.keystore)
                (inject() as UserStorageServiceInterface).storeCurrentUser()
                (inject() as AuthRouterInterface).showNext()
            })
            self.present(alert, animated: true)
        }
    }
    
    private func encodeCurrentUser() {
        guard let currentSeed = EssentiaStore.shared.currentUser.seed(withPassword: User.defaultPassword) else { return }
        EssentiaStore.shared.currentUser.encodedSeed = User.encrypt(data: currentSeed, password: self.store.password)
        EssentiaStore.shared.currentUser.seed = nil
        guard let currentMnemonic = EssentiaStore.shared.currentUser.mnemonic(withPassword: User.defaultPassword) else { return }
        EssentiaStore.shared.currentUser.encodedMnemonic = User.encrypt(data: currentMnemonic, password: self.store.password)
        EssentiaStore.shared.currentUser.mnemonic = nil
        (inject() as UserStorageServiceInterface).storeCurrentUser()
    }
    
    // MARK: - UIDocumentBrowserViewControllerDelegate
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { return }
        if url.startAccessingSecurityScopedResource() {
            NSFileCoordinator().coordinate(readingItemAt: url, options: .withoutChanges, error: nil) { (newUrl) in
                self.keystore = try? Data(contentsOf: newUrl)
            }
            url.stopAccessingSecurityScopedResource()
        }
    }
}
