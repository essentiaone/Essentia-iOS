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
        let loginType = EssentiaStore.currentUser.loginMethod
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(title: LS("Settings.Security.LoginMethod.Title")),
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
        EssentiaStore.currentUser.loginMethod = .mnemonic
        self.reloadState()
    }
    
    private lazy var seedAction: () -> Void = {
        EssentiaStore.currentUser.loginMethod = .seed
        self.reloadState()
    }
    
    private lazy var ketstoreAction: () -> Void = {
        EssentiaStore.currentUser.loginMethod = .keystore
        self.reloadState()
    }
}
