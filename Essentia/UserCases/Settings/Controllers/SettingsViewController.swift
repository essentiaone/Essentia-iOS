//
//  SettingsViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssCore
import EssResources
import EssUI
import EssDI

fileprivate struct Constants {
    static var separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
}

class SettingsViewController: BaseTableAdapterController, SelectAccountDelegate {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private var currentUserId = EssentiaStore.shared.currentUser.id
    private var currentSecurity = EssentiaStore.shared.currentUser.backup?.currentlyBackup?.secureLevel ?? 0
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateState()
        UIView.performWithoutAnimation {
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    
    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    private func updateState() {
        tableAdapter.hardReload(state)
    }
    
    override var state: [TableComponent] {
        return
            staticContent +
                [.tableWithCalculatableSpace(state: dynamicContent, background: colorProvider.settingsBackgroud)]
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
        let showSecureStatus = !(user.userEvents?.isAccountFullySecuredShown ?? false)
        let rawState: [TableComponent?] =
            [showSecureStatus ?
                .accountStrengthAction(action: accountStrenghtAction, status: secureAnimationStatus, currentLevel: currentSecurity):
                .empty(height: 16.0, background: colorProvider.settingsBackgroud),
             .currentAccount(icon: EssentiaStore.shared.currentUser.profile?.icon ?? UIImage(),
                             title: LS("Settings.CurrentAccountTitle"),
                             name: EssentiaStore.shared.currentUser.profile?.name ?? "",
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
                              detail: user.profile?.currency.titleString ?? "",
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
    
    private var appVersion: String {
        guard let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] else { return "v.404" }
        return "v. \(version)"
    }
    
    private var secureAnimationStatus: AnimationState {
        let newUser = EssentiaStore.shared.currentUser
        let shoudShowAnimation = currentSecurity != newUser.backup?.currentlyBackup?.secureLevel && currentUserId == newUser.id
        currentUserId = newUser.id
        currentSecurity = newUser.backup?.currentlyBackup?.secureLevel ?? 0
        if shoudShowAnimation {
            return .updating
        }
        return .idle
    }
    
    // MARK: - Actions
    private lazy var currencyAction: () -> Void = { [unowned self] in
        (inject() as SettingsRouterInterface).show(.currency)
    }
    
    private lazy var switchAccountAction: () -> Void = { [unowned self] in
        (inject() as SettingsRouterInterface).show(.switchAccount(self))
    }
    
    private lazy var logOutAction: () -> Void = { [unowned self] in
        self.logOutUser()
    }
    
    func logOutUser() {
        EssentiaStore.shared.setUser(.notSigned)
        prepareInjection(DefaultUserStorage() as UserStorageServiceInterface, memoryPolicy: .viewController)
        (inject() as SettingsRouterInterface).logOut()
    }
    
    private lazy var securityAction: () -> Void = { [unowned self] in
        switch EssentiaStore.shared.currentUser.backup?.currentlyBackup?.get() {
        case []:
            (inject() as SettingsRouterInterface).show(.backup(type: .keystore))
        default:
            (inject() as SettingsRouterInterface).show(.security)
        }
    }
    
    private lazy var languageAction: () -> Void = { [unowned self] in
        (inject() as SettingsRouterInterface).show(.language)
    }
    
    private lazy var accountStrenghtAction: () -> Void = { [unowned self] in
        switch EssentiaStore.shared.currentUser.backup?.currentlyBackup?.get() {
        case [.keystore, .seed, .mnemonic], [.keystore, .mnemonic, .seed]:
            (inject() as SettingsRouterInterface).show(.fullSecured)
        case []:
            (inject() as SettingsRouterInterface).show(.backup(type: .keystore))
        default:
            (inject() as SettingsRouterInterface).show(.accountStrength)
        }
    }
    
    private lazy var editCurrentAccountAction: () -> Void = { [unowned self] in
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.35) {
            (inject() as SettingsRouterInterface).show(.accountName)
        }
    }
    
    private lazy var feedbackAction: () -> Void = { [unowned self] in
        guard let url = URL(string: EssentiaConstants.reviewUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    // MARK: - SelectAccountDelegate
    func didSelectUser(_ user: ViewUser) {
        guard user.id != EssentiaStore.shared.currentUser.id else { return }
        present(LoginPasswordViewController(password: { [unowned self] (pass) in
            if pass.sha512().sha512() != user.passwordHash {
                return false
            }
            guard let userStore: UserStorageServiceInterface = try? RealmUserStorage(seedHash: user.id, password: pass) else { return false }
            prepareInjection(userStore, memoryPolicy: .viewController)
            (inject() as UserStorageServiceInterface).update { (user) in
                EssentiaStore.shared.setUser(user)
            }
            TabBarController.shared.selectedIndex = 0
            
            self.dismiss(animated: true)
            return true
            }, cancel: { [unowned self] in
                self.dismiss(animated: true)
        }), animated: true)
    }
    
    func didSetUser(user: User) -> Bool {
        TabBarController.shared.selectedIndex = 0
        return true
    }
    
    func createNewUser() {
        EssentiaLoader.show {}
        TabBarController.shared.selectedIndex = 0
        (inject() as LoginInteractorInterface).generateNewUser {}
    }
}
