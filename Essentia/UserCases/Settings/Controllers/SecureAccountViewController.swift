//
//  SecureAccountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssModel
import EssDI
import EssUI

class SecureAccountViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var router: SettingsRouterInterface = inject()
    
    // MARK: - Lifecycle
    
    private lazy var cashState: [TableComponent] = []
    
    override init() {
        super.init()
        self.cashState = state
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
        tableAdapter.hardReload(cashState)
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
        guard let currentUserBackups = EssentiaStore.shared.currentUser.backup?.currentlyBackup else { return [] }
        let secureLevel = currentUserBackups.secureLevel
        return [
            .accountStrength(backAction: backAction, currentLevel: secureLevel),
            .shadow(height: 10,
                    shadowColor: colorProvider.settingsShadowColor,
                    background: colorProvider.settingsBackgroud)]
            + mnemonicState +
            [.empty(height: 1, background: colorProvider.settingsBackgroud),
             .checkBox(state: ComponentState(defaultValue: currentUserBackups.contain(.seed)),
                       titlePrifex: LS("Settings.Secure.Prefix.Show"),
                       title: LS("Settings.Secure.Seed.Title"),
                       subtitle: LS("Settings.Secure.Seed.Description"),
                       action: seedAction),
             .empty(height: 1, background: colorProvider.settingsBackgroud),
             .checkBox(state:  ComponentState(defaultValue: currentUserBackups.contain(.keystore)),
                       titlePrifex: LS("Settings.Secure.Prefix.Save"),
                       title: LS("Settings.Secure.KeyStore.Title"),
                       subtitle: LS("Settings.Secure.KeyStore.Description"),
                       action: keyStoreAction),
             .empty(height: 8, background: colorProvider.settingsBackgroud),
             .description(title: LS("Settings.Secure.Description"),
                          backgroud: colorProvider.settingsBackgroud),
             .calculatbleSpace(background: colorProvider.settingsBackgroud)]
    }
    
    private var mnemonicState: [TableComponent] {
        guard let currentUserBackups = EssentiaStore.shared.currentUser.backup?.currentlyBackup else { return [] }
        guard EssentiaStore.shared.currentUser.mnemonic != nil else { return [] }
        return [
            .descriptionWithSize(aligment: .center,
                                 fontSize: 15,
                                 title: LS("Settings.Secure.Title"),
                                 background: colorProvider.settingsBackgroud,
                                 textColor: colorProvider.appDefaultTextColor),
            .empty(height: 8, background: colorProvider.settingsBackgroud),
            .checkBox(state:  ComponentState(defaultValue: currentUserBackups.contain(.mnemonic)),
                      titlePrifex: LS("Settings.Secure.Prefix.Save"),
                      title: LS("Settings.Secure.Mnemonic.Title"),
                      subtitle: LS("Settings.Secure.Mnemonic.Description"),
                      action: mnemonicAction)
        ]
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = { [unowned self] in
        self.router.pop()
    }
    
    private lazy var mnemonicAction: () -> Void = { [unowned self] in
        self.router.show(.backup(type: .mnemonic))
    }
    
    private lazy var seedAction: () -> Void = { [unowned self] in
        self.router.show(.backup(type: .seed))
    }
    
    private lazy var keyStoreAction: () -> Void = { [unowned self] in
        self.router.show(.backup(type: .keystore))
    }
}
