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

class SettingsViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateState()
        scrollToTop()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.addLastCellBackgroundContents(topColor: .white, bottomColor: colorProvider.settingsBackgroud)
        tableView.backgroundColor = .clear
    }
    
    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func updateState() {
        tableAdapter.hardReload(state)
    }
    
    private var state: [TableComponent] {
        let user = EssentiaStore.shared.currentUser
        let showSecureStatus = !user.userEvents.isAccountFullySecuredShown
        let rawState: [TableComponent?] =
            [.empty(height: 45, background: colorProvider.settingsCellsBackround),
             .titleWithFont(font: AppFont.bold.withSize(34),
                            title: LS("Settings.Title"),
                            background: colorProvider.settingsCellsBackround,
                            aligment: .left),
                showSecureStatus ?
                .accountStrengthAction(action: accountStrenghtAction) :
                .empty(height: 16.0, background: colorProvider.settingsBackgroud),
             .currentAccount(icon: user.profile.icon,
                             title: LS("Settings.CurrentAccountTitle"),
                             name: EssentiaStore.shared.currentUser.dislayName,
                             action: editCurrentAccountAction),
             .empty(height: 16.0, background: colorProvider.settingsBackgroud),
             .descriptionWithSize(aligment: .left,
                                  fontSize: 13,
                                  title: LS("Settings.Title.General"),
                                  background: colorProvider.settingsBackgroud,
                                  textColor: colorProvider.appDefaultTextColor),
             .empty(height: 5.0, background: colorProvider.settingsBackgroud),
//             .menuTitleDetail(icon: imageProvider.languageIcon,
//                              title: LS("Settings.Language"),
//                              detail: user.profile.language.titleString,
//                              action: languageAction),
//             .separator(inset: Constants.separatorInset),
             .menuTitleDetail(icon: imageProvider.currencyIcon,
                              title: LS("Settings.Currency"),
                              detail: user.profile.currency.titleString,
                              action: currencyAction),
             .separator(inset: Constants.separatorInset),
             .empty(height: 16, background: colorProvider.settingsBackgroud),
             .descriptionWithSize(aligment: .left,
                                  fontSize: 13,
                                  title: LS("Settings.Title.Security"),
                                  background: colorProvider.settingsBackgroud,
                                  textColor: colorProvider.appDefaultTextColor),
             .empty(height: 5.0, background: colorProvider.settingsBackgroud),
             .menuTitleDetail(icon: imageProvider.securityIcon,
                              title: LS("Settings.Security"),
                              detail: "",
                              action: securityAction),
             .separator(inset: Constants.separatorInset)]
             + loginMetodState +
             [.empty(height: 16, background: colorProvider.settingsBackgroud),
             .descriptionWithSize(aligment: .left,
                                  fontSize: 13,
                                  title: LS("Settings.Title.Community"),
                                  background: colorProvider.settingsBackgroud,
                                  textColor: colorProvider.appDefaultTextColor),
             .empty(height: 5.0, background: colorProvider.settingsBackgroud),
             .menuTitleDetail(icon: imageProvider.feedbackIcon,
                              title: LS("Settings.Feedback"),
                              detail: "",
                              action: feedbackAction),
             .separator(inset: Constants.separatorInset),
             .empty(height: 16, background: colorProvider.settingsBackgroud),
             .descriptionWithSize(aligment: .left,
                                  fontSize: 13,
                                  title: LS("Settings.Title.Application"),
                                  background: colorProvider.settingsBackgroud,
                                  textColor: colorProvider.appDefaultTextColor),
             .empty(height: 5.0, background: colorProvider.settingsBackgroud),
             .menuButton(title: LS("Settings.Switch"),
                         color: colorProvider.settingsMenuSwitchAccount,
                         action: switchAccountAction),
             .empty(height: 1, background: colorProvider.settingsBackgroud),
             .menuButton(title: LS("Settings.LogOut"),
                         color: colorProvider.settingsMenuLogOut,
                         action: logOutAction),
             .calculatbleSpace(background: colorProvider.settingsBackgroud),
             .empty(height: 8, background: colorProvider.settingsBackgroud),
             .description(title: appVersion, backgroud: colorProvider.settingsBackgroud),
             .empty(height: 8, background: colorProvider.settingsBackgroud)]
        return rawState.compactMap { return $0 }
    }
    
    private var loginMetodState: [TableComponent] {
        guard EssentiaStore.shared.currentUser.mnemonic != nil else { return [] }
        return [
            .menuSimpleTitleDetail(title: LS("Settings.Security.LoginMethod.Title"),
                                   detail: EssentiaStore.shared.currentUser.backup.loginMethod.titleString,
                                   withArrow: true,
                                   action: loginMethodAction),
            .separator(inset: Constants.separatorInset)
        ]
    }
    
    private func scrollToTop() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .bottom, animated: true)
    }
    
    private var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else { return "v.404" }
        return "v.\(version)"
    }
    
    // MARK: - Actions
    
    private lazy var loginMethodAction: () -> Void = {
        (inject() as SettingsRouterInterface).show(.loginType)
    }
    
    private lazy var currencyAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.currency)
    }
    
    private lazy var switchAccountAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.switchAccount(callBack: { [weak self] in
            self?.updateState()
        }))
    }
    private lazy var logOutAction: () -> Void = {
        self.logOutUser()
    }
    
    func logOutUser() {
        EssentiaStore.shared.setUser(.notSigned)
        (inject() as SettingsRouterInterface).logOut()
    }
    
    private lazy var darkThemeAction: (Bool) -> Void = { isOn in
        
    }
    
    private lazy var securityAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.security)
    }
    
    private lazy var languageAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.language)
    }
    
    private lazy var accountStrenghtAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.accountStrength)
    }
    
    private lazy var editCurrentAccountAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.accountName)
    }
    
    private lazy var feedbackAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.scrollToTop()
    }
}
