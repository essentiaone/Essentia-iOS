//
//  KeyStorePasswordViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

fileprivate struct Store {
    var password: String = ""
    var repeatPass: String = ""
    var isValid: Bool = false
    var isValidRepeate: Bool = false
    let authType: AuthType
    var keyboardHeight: CGFloat = 0
    var backupSourceType: BackupSourceType
    
    var isBothValid: Bool {
        if authType == .login {
            return !password.isEmpty
        }
        return isValid && isValidRepeate && password == repeatPass
    }
    
    var encodedPassword: Data {
        switch backupSourceType {
        case .web:
            return password.data(using: .utf8) ?? Data()
        default:
            return password.data(using: .utf8)?.sha3(.keccak256) ?? Data()
        }
    }
    
    init(authType: AuthType, backupSourceType: BackupSourceType) {
        self.authType = authType
        self.backupSourceType = backupSourceType
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
    private weak var delegate: SelectAccountDelegate?
    
    // MARK: - Init
    required init(_ auth: AuthType, delegate: SelectAccountDelegate, backupSourceType: BackupSourceType) {
        store = Store(authType: auth, backupSourceType: backupSourceType)
        self.delegate = delegate
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
            self.storeKeystore()
        case .login:
            self.decodeKeystore()
        }
    }
    
    private func decodeKeystore() {
        guard let data = self.keystore else { return }
        do {
            let decodedData = try (inject() as MnemonicServiceInterface).data(from: data, passwordData: self.store.encodedPassword)
            var user: User
            switch self.store.backupSourceType {
            case .web:
                let seed = decodedData.toHexString()
                user = User(seed: seed)
            default:
                let decodedString = String(data: decodedData, encoding: .utf8) ?? ""
                if decodedString.split(separator: " ").count == 12 {
                    user = User(mnemonic: decodedString)
                } else {
                    user = User(seed: decodedString)
                }
            }
            EssentiaStore.shared.setUser(user)
            user.backup?.currentlyBackup?.clear()
            user.backup?.currentlyBackup?.add(.keystore)
            (inject() as AuthRouterInterface).showPrev()
            delegate?.didSetUser(user: user)
        } catch {
            (inject() as LoaderInterface).showError(EssentiaError.unknownError.localizedDescription)
        }
    }
    
    private func showFilePicker() {
        let fileBrowser = UIDocumentPickerViewController(documentTypes: [], in: .open)
        fileBrowser.delegate = self
        isPickerShown = true
        present(fileBrowser, animated: true)
    }
    
    private func storeKeystore() {
        (inject() as LoaderInterface).show()
        do {
            let path = LocalFolderPath.final(Store.keyStoreFolder)
            let stringToStore = EssentiaStore.shared.currentUser.mnemonic ?? EssentiaStore.shared.currentUser.seed
            let keystore = try (inject() as MnemonicServiceInterface).keyStoreFile(stringData: stringToStore,
                                                                                   passwordData: self.store.encodedPassword)
            let url = try (inject() as LocalFilesServiceInterface).storeData(keystore,
                                                                             to: path,
                                                                             with: "\(EssentiaStore.shared.currentUser.id)")
            EssentiaStore.shared.currentUser.backup?.keystorePath = url.path
            EssentiaStore.shared.currentUser.backup?.currentlyBackup?.add(.keystore)
            let user = EssentiaStore.shared.currentUser
            let userStore: UserStorageServiceInterface = try RealmUserStorage(user: user, password: self.store.password)
            prepareInjection(userStore, memoryPolicy: .viewController)
        } catch {
            (inject() as LoggerServiceInterface).log(error.description)
        }
        self.showSuccess()
    }
    
    private func showSuccess() {
        OperationQueue.main.addOperation {
            (inject() as LoaderInterface).hide()
            let alert = KeystoreSavedAlert(okAction: {
                (inject() as AuthRouterInterface).showNext()
            })
            self.present(alert, animated: true)
        }
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
