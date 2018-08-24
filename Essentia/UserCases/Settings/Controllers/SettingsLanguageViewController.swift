//
//  SettingsLanguageViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class SettingsLanguageViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: SettingsRouterInterface = inject()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
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
            .title(title: LS("Settings.Language.Title"))
            ] + languageState
    }
    
    var languageState: [TableComponent] {
        var languageComponent: [TableComponent] = []
        let currenyLanguage = EssentiaStore.currentUser.language
        LocalizationLanguage.cases.forEach { (language) in
            languageComponent.append(.menuTitleCheck(
                title: language.rawValue,
                state: ComponentState(defaultValue: currenyLanguage == language),
                action: {
                    EssentiaStore.currentUser.language = language
                    self.tableAdapter.reload(self.state)
                    self.showFlipAnimation()
            }))
            languageComponent.append(.separator(inset: .zero))
        }
        return languageComponent
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = {
        self.router.pop()
    }
    
    private lazy var keyStoreAction: () -> Void = {
        self.router.show(.backupKeystore)
    }
}
