//
//  WelcomeViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssUI
import EssDI
import EssResources
import RealmSwift

class WelcomeViewController: BaseTableAdapterController, ImportAccountDelegate, SelectAccountDelegate {
    
    // MARK: - Dependences
    private lazy var interactor: LoginInteractorInterface = inject()
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    private lazy var userStorage: UserStorageServiceInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var loader: LoaderInterface = inject()
    private lazy var purchaseService: PurchaseServiceInterface = PurchaseService()
    private var lastSource: BackupSourceType?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableAdapter.hardReload(state)
    }
    
    // MARK: - State
    override var state: [TableComponent] {
        return [
            .empty(height: 40, background: colorProvider.settingsCellsBackround),
            .borderedButton(title: LS("Welcome.Restore"),
                                 action: restoreAction,
                                 borderColor: colorProvider.borderedButtonBorderColor.cgColor,
                                 borderWidth: 2),
            .empty(height: 88, background: colorProvider.settingsCellsBackround),
            .titleWithFontAligment(font: AppFont.regular.withSize(36),
                                   title: LS("Welcome.Title1"),
                                   aligment: .left,
                                   color: colorProvider.appTitleColor),
            .titleWithFontAligment(font: AppFont.bold.withSize(36),
                                   title: LS("Welcome.Title2"),
                                   aligment: .left,
                                   color: colorProvider.appTitleColor),
            .calculatbleSpace(background: .clear),
            .centeredButton(title: userService.users.isEmpty ? LS("Welcome.Start") : LS("Welcome.Enter"),
                            isEnable: true,
                            action: enterAction,
                            background: colorProvider.settingsCellsBackround),
            .attributedCenteredButton(attributedTitle: termsTitle,
                                      action: termsAction,
                                      textColor: colorProvider.appLinkTextColor,
                                      background: .clear),
            .empty(height: 10, background: colorProvider.settingsCellsBackround)]
    }
    
    private var termsTitle: NSMutableAttributedString {
        let termsAttributedText = NSMutableAttributedString()
        termsAttributedText.append(
            NSAttributedString(
                string: LS("Welcome.Tersm1"),
                attributes: [.font: AppFont.regular.withSize(13)]
            )
        )
        termsAttributedText.append(
            NSAttributedString(
                string: LS("Welcome.Tersm2"),
                attributes: [.font: AppFont.regular.withSize(13),
                             .underlineStyle: NSUnderlineStyle.single.rawValue]
            )
        )
        return termsAttributedText
    }
    
    // MARK: - Actions
    private lazy var restoreAction: () -> Void = { [unowned self] in
        self.present(ImportAccountViewController(delegate: self), animated: true)
    }
    
    private lazy var enterAction: () -> Void = { [unowned self] in
        if self.userService.users.isEmpty {
            self.createNewUser()
            return
        }
        self.present(SelectAccoutViewController(self), animated: true)
    }
    
    private lazy var termsAction: () -> Void = { [unowned self] in
        guard let url = URL(string: EssentiaConstants.termsUrl) else { return }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }

    // MARK: - RestoreAccountDelegate
    func importAccountWith(sourceType: BackupSourceType, backupType: BackupType) {
        self.lastSource = sourceType
        dismiss(animated: true)
        let nvc = UINavigationController()
        nvc.setNavigationBarHidden(true, animated: false)
        self.present(nvc, animated: true)
        prepareInjection(AuthRouter(navigationController: nvc,
                                    type: backupType,
                                    auth: .login,
                                    delegate: self,
                                    sourceType: sourceType) as AuthRouterInterface,
                         memoryPolicy: .viewController)
    }
    
    // MARK: - SelectAccountDelegate
    func didSelectUser(_ user: ViewUser) {
        present(LoginPasswordViewController(userId: user.id, hash: user.passwordHash, password: { [unowned self] pass in
            guard let userStore: UserStorageServiceInterface = try? RealmUserStorage(seedHash: user.id, password: pass) else { return }
            prepareInjection(userStore, memoryPolicy: ObjectScope.viewController)
            (inject() as UserStorageServiceInterface).update { (user) in
                EssentiaStore.shared.setUser(user)
                self.dismiss(animated: true, completion: { [unowned self] in
                    self.showTabBar()
                })
            }
            }, cancel: { [unowned self] in
                self.dismiss(animated: true)
        }), animated: true)
    }
    
    func didSetUser(user: User) -> Bool {
        let viewUsers = userService.users
        let userAlreadyExist = viewUsers.contains(where: { $0.id == user.id })
        guard !userAlreadyExist else {
            EssentiaStore.shared.currentUser = User()
            loader.showError(EssentiaError.userExist.localizedDescription)
            return false
        }
        let wallets: List<GeneratingWalletInfo> = List()
        let sourceType = lastSource ?? .app
        Coin.fullySupportedCoins.forEach({ (coin) in
            wallets.append(GeneratingWalletInfo(coin: coin, sourceType: sourceType, seed: user.seed))
        })
        user.wallet?.generatedWalletsInfo = wallets
        showTabBar()
        return true
    }
    
    func showTabBar() {
        TabBarController.shared.selectedIndex = 0
        self.present(TabBarController.shared, animated: true)
    }
    
    func createNewUser() {
        let accountsCount = userService.users.count
        let purchaseAddress = UserDefaults.standard.string(forKey: EssDefault.purchaseAddress.rawValue)
        
        guard accountsCount >= EssentiaConstants.freeAccountsCount else {
            generateAccount()
            return
        }
        
        guard let address = purchaseAddress else {
            openPurhcase()
            return
        }
        
        purchaseService.getPurchaseType(for: address) { (purchaseType) in
            switch purchaseType {
            case .unlimited:
                self.generateAccount()
            case .singeAccount(let count):
                if count + EssentiaConstants.freeAccountsCount <= accountsCount {
                    self.generateAccount()
                } else {
                    self.openPurhcase()
                }
            case .notPurchased:
                self.openPurhcase()
            case .error(let error):
                self.showInfo(error.localizedDescription, type: .error)
            }
        }
    }
    
    private func openPurhcase() {
        present(SelectPurchaseViewController(), animated: true)
    }
    
    func generateAccount() {
        EssentiaLoader.show { [unowned self] in
            self.showTabBar()
        }
        interactor.generateNewUser {}
    }
}
