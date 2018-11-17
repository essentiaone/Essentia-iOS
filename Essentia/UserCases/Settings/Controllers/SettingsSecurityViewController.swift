//
//  SettingsSecurityViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 28.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class SettingsSecurityViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: SettingsRouterInterface = inject()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        applyDesign()
    }
    
    // MARK: - Design
    private func applyDesign() {
        tableView.backgroundColor = colorProvider.settingsBackgroud
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(bold: true, title: LS("Settings.Security.Title")),
            .empty(height: 22.0, background: colorProvider.settingsBackgroud),
            .menuSectionHeader(title: LS("Settings.Security.SectionHeader"),
                               backgroud: colorProvider.settingsBackgroud),
            .menuSimpleTitleDetail(title: LS("Settings.Security.Mnemonic.Title"),
                                   detail: LS("Settings.Security.Mnemonic.Detail"),
                                   withArrow: true,
                                   action: mnemonicAction),
            .separator(inset: .zero),
            .menuSimpleTitleDetail(title: LS("Settings.Security.Seed.Title"),
                                   detail: LS("Settings.Security.Seed.Detail"),
                                   withArrow: true,
                                   action: seedAction),
            .separator(inset: .zero),
            .menuSimpleTitleDetail(title: LS("Settings.Security.Keystore.Title"),
                                   detail: LS("Settings.Security.Keystore.Detail"),
                                   withArrow: false,
                                   action: ketstoreAction),
            .separator(inset: .zero),
            .empty(height: 16.0, background: colorProvider.settingsBackgroud),
            .menuSimpleTitleDetail(title: LS("Settings.Security.LoginMethod.Title"),
                                   detail: EssentiaStore.shared.currentUser.backup.loginMethod.titleString,
                                   withArrow: true,
                                   action: loginMethodAction),
            .separator(inset: .zero),
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
            (inject() as SettingsRouterInterface).show(.backup(type: .mnemonic))
            return
        }
    }
    
    private lazy var seedAction: () -> Void = {
        (inject() as SettingsRouterInterface).show(.backup(type: .seed))
    }
    
    private lazy var ketstoreAction: () -> Void = {
        guard EssentiaStore.shared.currentUser.backup.currentlyBackedUp.contains(.keystore),
              let keystore = EssentiaStore.shared.currentUser.backup.keystoreUrl else {
            (inject() as SettingsRouterInterface).show(.backup(type: .keystore))
            return
        }
        (inject() as SettingsRouterInterface).show(.activity(fileUrl: keystore))
    }
    
    private lazy var loginMethodAction: () -> Void = {
        (inject() as SettingsRouterInterface).show(.loginType)
    }
}
