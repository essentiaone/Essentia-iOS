//
//  LoginPasswordViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/21/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import UIKit

fileprivate struct Store {
    var password: String = ""
    var keyboardHeight: CGFloat = 0
}

class LoginPasswordViewController: BaseTableAdapterController {
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Store
    private var store = Store()
    private var passwordCallback: ((String) -> Void)?
    private var cancelCallback: (() -> Void)?
    
    // MARK: - Init
    required init(password: @escaping (String) -> Void, cancel: @escaping () -> Void) {
        self.passwordCallback = password
        self.cancelCallback = cancel
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardObserver.start()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver.animateKeyboard = { newValue in
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
            .empty(height: 10.0, background: colorProvider.settingsCellsBackround),
            .password(title: LS("Keystore.PasswordField.Title"), withProgress: false, passwordAction: passwordAction),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("SeedCopy.Continue"),
                            isEnable: !self.store.password.isEmpty,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: store.keyboardHeight, background: colorProvider.settingsBackgroud)
        ]
    }
    
    // MARK: - Actions
    private lazy var passwordAction: (Bool, String) -> Void = {
        self.store.password = $1
        self.updateState()
    }
    
    private lazy var backAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        (inject() as AuthRouterInterface).showPrev()
        self.cancelCallback?()
    }
    
    private lazy var continueAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.passwordCallback?(self.store.password)
    }
}
