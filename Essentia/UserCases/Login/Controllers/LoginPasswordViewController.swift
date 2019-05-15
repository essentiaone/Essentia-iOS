//
//  LoginPasswordViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/21/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import UIKit
import EssCore
import EssResources
import EssUI
import EssDI
import EssModel
import KeychainAccess

fileprivate struct Store {
    var password: String = ""
    var keyboardHeight: CGFloat = 0
}

class LoginPasswordViewController: BaseTableAdapterController {
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var keystoreService: KeychainServiceInterface = inject()
    private lazy var viewUserService: ViewUserStorageServiceInterface = inject()
    
    // MARK: - Store
    private var store = Store()
    private var passwordCallback: ((String) -> Void)?
    private var cancelCallback: (() -> Void)?
    private var userId: String
    private var passwordHash: String
    
    // MARK: - Init
    required init(userId: String, hash: String, password: @escaping (String) -> Void, cancel: @escaping () -> Void) {
        self.passwordCallback = password
        self.passwordHash = hash
        self.cancelCallback = cancel
        self.userId = userId
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableAdapter.hardReload(state)
        keyboardObserver.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
        if isTouchIdEnabled {
            getPasswordWithTouchId()
        }
    }
    
    private func updateState() {
        tableAdapter.simpleReload(state)
    }
    
    override var state: [TableComponent] {
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
            .password(title: LS("Keystore.PasswordField.Title"), withProgress: false, passwordAction: passwordAction)]
            + touchIdState +
            [.calculatbleSpace(background: colorProvider.settingsCellsBackround),
             .centeredButton(title: LS("SeedCopy.Continue"),
                             isEnable: !self.store.password.isEmpty,
                             action: continueAction,
                             background: colorProvider.settingsCellsBackround),
             .empty(height: 10, background: colorProvider.settingsCellsBackround),
             .empty(height: store.keyboardHeight, background: colorProvider.settingsBackgroud)
        ]
    }
    
    private var touchIdState: [TableComponent] {
        if !isTouchIdEnabled { return [] }
        return [.empty(height: 10.0, background: colorProvider.settingsCellsBackround),
                .centeredImageButton(image: imageProvider.touchIdIcon, action: getPasswordWithTouchId)]
    }
    
    private var isTouchIdEnabled: Bool {
        let user = viewUserService.users.first { return $0.id == self.userId }
        return user?.isTouchIdEnabled ?? false
    }
    
    // MARK: - Actions
    private lazy var passwordAction: (Bool, String) -> Void = { [unowned self] in
        self.store.password = $1
        self.updateState()
    }
    
    private lazy var backAction: () -> Void = { [unowned self] in
        self.tableAdapter.endEditing(true)
        self.cancelCallback?()
    }
    
    private lazy var getPasswordWithTouchId: () -> Void = { [unowned self] in
        self.tableAdapter.endEditing(true)
        self.keystoreService.getPassword(userId: self.userId, result: { result in
            switch result {
            case .success(let pass):
                self.store.password = pass ?? ""
                self.tableAdapter.simpleReload(self.state)
                self.continueAction()
            default: return
            }
        })
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        guard let validatePasswordCallback = self.passwordCallback else { return }
        let password = self.store.password
        if password.sha512().sha512() == self.passwordHash {
            self.passwordCallback?(password)
            self.keyboardObserver.stop()
            self.tableAdapter.endEditing(true)
        } else {
            self.showInfo(EssentiaError.wrongPassword.localizedDescription, type: .error)
        }
    }
}
