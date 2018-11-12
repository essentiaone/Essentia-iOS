//
//  SettingsLoginMethodViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 28.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class SettingsLoginMethodViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: SettingsRouterInterface = inject()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadState()
        applyDesign()
    }
    
    // MARK: - Design
    private func applyDesign() {
        tableView.backgroundColor = colorProvider.settingsBackgroud
    }
    
    private func reloadState() {
        tableAdapter.reload(state)
    }
    
    private var state: [TableComponent] {
        let loginType = EssentiaStore.shared.currentUser.backup.loginMethod
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(bold: true, title: LS("Settings.Security.LoginMethod.Title")),
            .empty(height: 22.0, background: colorProvider.settingsBackgroud),
            .menuSectionHeader(title: LS("Settings.Security.SectionHeader"),
                               backgroud: colorProvider.settingsBackgroud),
            .menuTitleCheck(title: LS("Settings.Security.Mnemonic.Title"),
                            state: ComponentState(defaultValue: loginType == .mnemonic) ,
                            action: mnemonicAction),
            .separator(inset: .zero),
            .menuTitleCheck(title: LS("Settings.Security.Seed.Title"),
                            state: ComponentState(defaultValue: loginType == .seed),
                            action: seedAction),
            .separator(inset: .zero),
            .menuTitleCheck(title: LS("Settings.Security.Keystore.Title"),
                            state: ComponentState(defaultValue: loginType == .keystore),
                            action: ketstoreAction),
            .description(title: LS("Settings.Secure.Description"),
                         backgroud: colorProvider.settingsBackgroud)
        ]
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = {
        self.router.pop()
    }
    
    private lazy var mnemonicAction: () -> Void = {
        guard EssentiaStore.shared.currentUser.backup.currentlyBackedUp.contains(.mnemonic) else {
            self.showBackupMnemonicAlert()
            return
        }
        EssentiaStore.shared.currentUser.backup.loginMethod = .mnemonic
        (inject() as UserStorageServiceInterface).storeCurrentUser()
        self.reloadState()
    }
    
    private lazy var seedAction: () -> Void = {
        EssentiaStore.shared.currentUser.backup.loginMethod = .seed
        (inject() as UserStorageServiceInterface).storeCurrentUser()
        self.reloadState()
    }
    
    private lazy var ketstoreAction: () -> Void = {
        EssentiaStore.shared.currentUser.backup.loginMethod = .keystore
        (inject() as UserStorageServiceInterface).storeCurrentUser()
        self.reloadState()
    }
    
    private func showBackupMnemonicAlert() {
        let alert = BackupMnemonicAlert(leftAction: {}, rightAction: {
            (inject() as SettingsRouterInterface).show(.backupMenmonic)
        })
        present(alert, animated: true)
    }
}
