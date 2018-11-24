//
//  SettingsSecurityViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 28.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

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
            .navigationBar(left: LS("Settings.Title"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(bold: true, title: LS("Settings.Security.Title")),
            .empty(height: 22.0, background: colorProvider.settingsBackgroud),
            .menuSectionHeader(title: LS("Settings.Security.SectionHeader"),
                               backgroud: colorProvider.settingsBackgroud)]
            + mnemonicState +
            [.menuSimpleTitleDetail(title: LS("Settings.Security.Seed.Title"),
                                    detail: LS("Settings.Security.Seed.Detail"),
                                    withArrow: true,
                                    action: seedAction),
             .separator(inset: .zero)]
            + keystoreState
    }
    
    private var keystoreState: [TableComponent] {
        guard EssentiaStore.shared.currentUser.mnemonic != nil else { return [] }
        return [.menuSimpleTitleDetail(title: LS("Settings.Security.Keystore.Title"),
                                       detail: LS("Settings.Security.Keystore.Detail"),
                                       withArrow: false,
                                       action: ketstoreAction),
                .separator(inset: .zero)]
    }
    
    var mnemonicState: [TableComponent] {
        guard EssentiaStore.shared.currentUser.mnemonic != nil else { return [] }
        return [ .menuSimpleTitleDetail(title: LS("Settings.Security.Mnemonic.Title"),
                                        detail: LS("Settings.Security.Mnemonic.Detail"),
                                        withArrow: true,
                                        action: mnemonicAction),
                 .separator(inset: .zero)]
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
            let keystore = EssentiaStore.shared.currentUser.backup.keystoreUrl,
            (try? Data(contentsOf: keystore)) != nil  else {
                (inject() as SettingsRouterInterface).show(.backup(type: .keystore))
                return
        }
        self.present(UIActivityViewController(activityItems: [keystore], applicationActivities: nil), animated: true)
    }
}
