//
//  SettingsLanguageViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

class SettingsLanguageViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: SettingsRouterInterface = inject()
    private let currentLanguage = EssentiaStore.shared.currentUser.profile?.language ?? .english
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    // MARK: - Design
    private func applyDesign() {
        tableView.backgroundColor = colorProvider.settingsBackgroud
    }
    
    override var state: [TableComponent] {
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
        return LocalizationLanguage.cases |> buildLanguageState |> concat
    }
    
    private func buildLanguageState(_ language: LocalizationLanguage) -> [TableComponent] {
        return [
            .menuTitleCheck(
                title: language.titleString,
                state: ComponentState(defaultValue: currentLanguage == language),
                action: { [unowned self] in
                    (inject() as UserStorageServiceInterface).update({ (user) in
                        user.profile?.language = language
                    })
                    self.tableAdapter.hardReload(self.state)
                    self.showFlipAnimation()
            }),
            .separator(inset: .zero)]
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [unowned self] in
        self.router.pop()
    }
    
    private lazy var keyStoreAction: () -> Void = { [unowned self] in
        self.router.show(.backup(type: .keystore))
    }
}
