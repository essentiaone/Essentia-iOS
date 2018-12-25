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

class SettingsViewController: BaseTableAdapterController, SelectAccountDelegate {
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
        return [
            .tableWithHeight(height: 91, state: staticContent),
            .tableWithCalculatableSpace(state: dynamicContent)
        ]
    }
    
    private var staticContent: [TableComponent] {
        return [.empty(height: 45, background: colorProvider.settingsCellsBackround),
                .titleWithFont(font: AppFont.bold.withSize(34),
                               title: LS("Settings.Title"),
                               background: colorProvider.settingsCellsBackround,
                               aligment: .left)]
    }
    
    private var dynamicContent: [TableComponent] {
        let user = EssentiaStore.shared.currentUser
        let showSecureStatus = !user.userEvents.isAccountFullySecuredShown
        let rawState: [TableComponent?] =
            [showSecureStatus ?
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
             .separator(inset: Constants.separatorInset),
             .empty(height: 16, background: colorProvider.settingsBackgroud),
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
             .descriptionWithSize(aligment: .center,
                                  fontSize: 14,
                                  title: appVersion,
                                  background: colorProvider.settingsBackgroud,
                                  textColor: colorProvider.appDefaultTextColor),
             .empty(height: 8, background: colorProvider.settingsBackgroud)]
        return rawState.compactMap { return $0 }
    }

    private var loginMetodState: [TableComponent] {
        guard EssentiaStore.shared.currentCredentials.mnemonic != nil else { return [] }
        return [
            .menuSimpleTitleDetail(title: LS("Settings.Security.LoginMethod.Title"),
                                   detail: EssentiaStore.shared.currentUser.backup.loginMethod.titleString,
                                   withArrow: true,
                                   action: loginMethodAction),
            .separator(inset: Constants.separatorInset)
        ]
    }
    
    private func scrollToTop() {
        UIView.setAnimationsEnabled(false)
        tableView.contentOffset = .zero
        UIView.setAnimationsEnabled(true)
    }
    
    private var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else { return "v.404" }
        return "v. \(version)"
    }
    
    // MARK: - Actions
    private lazy var loginMethodAction: () -> Void = {
        (inject() as SettingsRouterInterface).show(.loginType)
    }
    
    private lazy var currencyAction: () -> Void = { [unowned self] in
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.currency)
    }
    
    private lazy var switchAccountAction: () -> Void = { [unowned self] in
        (inject() as SettingsRouterInterface).show(.switchAccount(self))
    }
    
    private lazy var logOutAction: () -> Void = { [unowned self] in
        self.scrollToTop()
        self.logOutUser()
    }
    
    func logOutUser() {
        removeCurrentUserIfNeeded()
        try? EssentiaStore.shared.setUser(.notSigned, password: "")
        (inject() as SettingsRouterInterface).logOut()
    }
    
    private lazy var securityAction: () -> Void = { [unowned self] in
        self.scrollToTop()
        if !EssentiaStore.shared.currentUser.backup.currentlyBackedUp.contains(.keystore) {
            (inject() as SettingsRouterInterface).show(.backupKeystore)
        } else {
            (inject() as SettingsRouterInterface).show(.security)
        }
    }
    
    private lazy var languageAction: () -> Void = { [unowned self] in
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.language)
    }
    
    private lazy var accountStrenghtAction: () -> Void = { [unowned self] in
        self.scrollToTop()
        if !EssentiaStore.shared.currentUser.backup.currentlyBackedUp.contains(.keystore) {
            (inject() as SettingsRouterInterface).show(.backupKeystore)
        } else {
            (inject() as SettingsRouterInterface).show(.accountStrength)
        }
    }
    
    private lazy var editCurrentAccountAction: () -> Void = { [unowned self] in
        self.scrollToTop()
        (inject() as SettingsRouterInterface).show(.accountName)
    }
    
    private lazy var feedbackAction: () -> Void = { [unowned self] in
        guard let url = URL(string: EssentiaConstants.reviewUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
        self.scrollToTop()
    }
    
    // MARK: - SelectAccountDelegate
    func didSelectUser(_ user: User) {
        guard user.id != EssentiaStore.shared.currentUser.id else {
            return
        }
        scrollToTop()
        removeCurrentUserIfNeeded()
        guard user.seed == nil else {
            try? EssentiaStore.shared.setUser(user, password: User.defaultPassword)
            user.backup.currentlyBackedUp = []
            return
        }
        present(LoginPasswordViewController(password: { [unowned self] (pass) in
            do {
                try EssentiaStore.shared.setUser(user, password: pass)
            } catch {
                (inject() as LoaderInterface).showError(error)
                return false
            }
            self.dismiss(animated: true)
            return true
        }, cancel: { [unowned self] in
            self.dismiss(animated: true)
        }), animated: true)
    }
    
    func removeCurrentUserIfNeeded() {
        let currentUser = EssentiaStore.shared.currentUser
        let isOldAccount = EssentiaStore.shared.currentUser.seed != nil
        let isNotBackuped = currentUser.backup.currentlyBackedUp.isEmpty
        if isNotBackuped && !isOldAccount {
            (inject() as UserStorageServiceInterface).remove(user: currentUser)
        }
    }
    
    func createNewUser() {
        scrollToTop()
        removeCurrentUserIfNeeded()
        EssentiaLoader.show {}
        TabBarController.shared.selectedIndex = 0
        (inject() as LoginInteractorInterface).generateNewUser {}
    }
}
