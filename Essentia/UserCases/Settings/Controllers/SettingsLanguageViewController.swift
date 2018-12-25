//
//  SettingsLanguageViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class SettingsLanguageViewController: BaseTableAdapterController, SwipeableNavigation {
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
            .title(bold: true, title: LS("Settings.Language.Title"))
            ] + languageState
    }
    
    var languageState: [TableComponent] {
        var languageComponent: [TableComponent] = []
        let currenyLanguage = EssentiaStore.shared.currentUser.profile.language
        LocalizationLanguage.cases.forEach { (language) in
            languageComponent.append(.menuTitleCheck(
                title: language.titleString,
                state: ComponentState(defaultValue: currenyLanguage == language),
                action: { [unowned self] in
                    EssentiaStore.shared.currentUser.profile.language = language
                    (inject() as UserStorageServiceInterface).storeCurrentUser()
                    self.tableAdapter.hardReload(self.state)
                    self.showFlipAnimation()
            }))
            languageComponent.append(.separator(inset: .zero))
        }
        return languageComponent
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = { [unowned self] in
        self.router.pop()
    }
    
    private lazy var keyStoreAction: () -> Void = { [unowned self] in
        self.router.show(.backupKeystore)
    }
}
