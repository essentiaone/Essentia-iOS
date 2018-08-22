//
//  SecureAccountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SecureAccountViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var router: SettingsRouterInterface = inject()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDesign()
        tableAdapter.reload(state)
    }
    
    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Design
    private func applyDesign() {
        tableView.backgroundColor = colorProvider.settingsCellsBackround
    }
    
    private var state: [TableComponent] {
        return [
            .accountStrength(progress: 10, backAction: backAction),
            .checkBox(state:  ComponentState(defaultValue: true),
            titlePrifex: LS("Settings.Secure.Prefix.Save"),
                      title: LS("Settings.Secure.Mnemonic.Title"),
                      subtitle: LS("Settings.Secure.Mnemonic.Description"),
                      action: mnemonicAction),
            .empty(height: 1, background: colorProvider.settingsBackgroud),
            .checkBox(state: ComponentState(defaultValue: true),
                      titlePrifex: LS("Settings.Secure.Prefix.Show"),
                      title: LS("Settings.Secure.Seed.Title"),
                      subtitle: LS("Settings.Secure.Seed.Description"),
                      action: seedAction),
            .empty(height: 1, background: colorProvider.settingsBackgroud),
            .checkBox(state:  ComponentState(defaultValue: false),
                      titlePrifex: LS("Settings.Secure.Prefix.Save"),
                      title: LS("Settings.Secure.KeyStore.Title"),
                      subtitle: LS("Settings.Secure.KeyStore.Description"),
                      action: keyStoreAction),
            .empty(height: 8, background: colorProvider.settingsBackgroud),
            .description(title: LS("Settings.Secure.Description"),
                         backgroud: colorProvider.settingsBackgroud),
            .empty(height: 20, background: colorProvider.settingsBackgroud)
        ]
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = {
        self.router.pop()
    }
    
    private lazy var mnemonicAction: () -> Void = {
        self.router.show(.backupMenmonic)
    }
    
    private lazy var seedAction: () -> Void = {
        self.router.show(.backupSeed)
    }
    
    private lazy var keyStoreAction: () -> Void = {
        self.router.show(.backupKeystore)
    }
}
