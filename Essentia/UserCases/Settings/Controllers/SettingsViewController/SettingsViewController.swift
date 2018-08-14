//
//  SettingsViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
}

class SettingsViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private lazy var tableAdapter = TableAdapter(tableView: tableView)
    
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    private var currentLanguage: String = "English"
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        injectRouter()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDesign()
        tableAdapter.updateState(state)
    }
    
    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func injectRouter() {
        guard let navigation = navigationController else { return }
        let injection: SettingsRouterInterface = SettingsRouter(navigationController: navigation)
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func applyDesign() {
        tableView.backgroundColor = colorProvider.settingsCellsBackround
    }
    
    private var state: [TableComponent] {
        return [.empty(height: 45, background: colorProvider.settingsCellsBackround),
                .title(title: LS("Settings.Title")),
                .accountStrengthAction(progress: 10, action: accountStrenghtAction),
                .currentAccount(icon: imageProvider.testAvatarIcon,
                                title: LS("Settings.CurrentAccountTitle"),
                                name: "Test",
                                action: editCurrentAccountAction),
                .empty(height: 16.0, background: colorProvider.settingsBackgroud),
                .menuTitleDetail(icon: imageProvider.languageIcon,
                                 title: LS("Settings.Language"),
                                 detail: currentLanguage,
                                 action: languageAction),
                .separator(inset: Constants.separatorInset),
                .menuTitleDetail(icon: imageProvider.currencyIcon,
                                 title: LS("Settings.Currency"),
                                 detail: "USD",
                                 action: languageAction),
                .separator(inset: Constants.separatorInset),
                .menuTitleDetail(icon: imageProvider.securityIcon,
                                 title: LS("Settings.Security"),
                                 detail: "",
                                 action: languageAction),
                .separator(inset: Constants.separatorInset),
                .empty(height: 16, background: colorProvider.settingsBackgroud),
                TableComponent.menuSwitch(icon: imageProvider.darkThemeIcon,
                                          title: LS("Settings.DarkTheme"),
                                          state: ComponentState(defaultValue: false),
                                          action: darkThemeAction),
                .separator(inset: Constants.separatorInset),
                .menuTitleDetail(icon: imageProvider.feedbackIcon,
                                 title: LS("Settings.Feedback"),
                                 detail: "",
                                 action: languageAction),
                .separator(inset: Constants.separatorInset),
                .empty(height: 16, background: colorProvider.settingsBackgroud),
                .menuButton(title: LS("Settings.Switch"),
                            color: colorProvider.settingsMenuSwitchAccount,
                            action: switchAccountAction),
                .empty(height: 1, background: colorProvider.settingsBackgroud),
                .menuButton(title: LS("Settings.LogOut"),
                            color: colorProvider.settingsMenuLogOut,
                            action: logOutAction),
                .empty(height: 24, background: colorProvider.settingsBackgroud)
        ]
    }
    
    // MARK: - Actions
    
    private lazy var switchAccountAction: () -> Void = {
        
    }
    
    private lazy var logOutAction: () -> Void = {
        
    }
    
    private lazy var darkThemeAction: (Bool) -> Void = { isOn in
        
    }
    
    private lazy var languageAction: () -> Void = {
        
    }
    
    private lazy var accountStrenghtAction: () -> Void = {
        (inject() as SettingsRouterInterface).show(.accountStrength)
    }
    
    private lazy var editCurrentAccountAction: () -> Void = {
        
    }
}
