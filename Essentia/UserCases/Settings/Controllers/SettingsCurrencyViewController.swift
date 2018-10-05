//
//  SettingsCurrencyViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class SettingsCurrencyViewController: BaseTableAdapterController {
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
            .title(bold: true, title: LS("Settings.Currency.Title"))
        ] + currenciesState
    }
    
    var currenciesState: [TableComponent] {
        var currencyState: [TableComponent] = []
        let currenyCurrency = EssentiaStore.currentUser.profile.currency
        Currency.cases.forEach { (currency) in
            currencyState.append(.menuTitleCheck(
                title: currency.titleString,
                state: ComponentState(defaultValue: currenyCurrency == currency),
                action: {
                    EssentiaStore.currentUser.profile.currency = currency
                    (inject() as CurrencyRankDemonInterface).update()
                    self.tableAdapter.reload(self.state)
            }))
            currencyState.append(.separator(inset: .zero))
        }
        return currencyState
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = {
        self.router.pop()
    }
    
    private lazy var keyStoreAction: () -> Void = {
        self.router.show(.backupKeystore)
    }
}
