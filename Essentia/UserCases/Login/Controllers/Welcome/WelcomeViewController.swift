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

class WelcomeViewController: BaseViewController, ImportAccountDelegate, SelectAccountDelegate {
    
    // MARK: - IBOutlet
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var enterButton: CenteredButton!
    @IBOutlet weak var termsButton: UIButton!
    
    // MARK: - Dependences
    private lazy var interactor: LoginInteractorInterface = inject()
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    private var lastSource: BackupSourceType?
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyDesign()
    }
    
    func applyDesign() {
        restoreButton.setTitle(LS("Welcome.Restore"), for: .normal)
        title1Label.text = LS("Welcome.Title1")
        title2Label.text = LS("Welcome.Title2")
        if (inject() as ViewUserStorageServiceInterface).users.isEmpty {
            enterButton.setTitle(LS("Welcome.Start"), for: .normal)
        } else {
            enterButton.setTitle(LS("Welcome.Enter"), for: .normal)
        }
        
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
        termsButton.setAttributedTitle(termsAttributedText, for: .normal)
        
        // MARK: - Colors
        title1Label.textColor = colorProvider.appTitleColor
        title2Label.textColor = colorProvider.appTitleColor
        termsButton.titleLabel?.textColor = colorProvider.appLinkTextColor
        
        // MARK: - Font
        title1Label.font = AppFont.regular.withSize(36)
        title2Label.font = AppFont.bold.withSize(36)
    }
    
    // MARK: - Actions
    @IBAction func restoreAction(_ sender: Any) {
        present(ImportAccountViewController(delegate: self), animated: true)
    }
    
    @IBAction func enterAction(_ sender: Any) {
        if userService.users.isEmpty {
            createNewUser()
            return
        }
        present(SelectAccoutViewController(self), animated: true)
    }
    
    @IBAction func termsAction(_ sender: Any) {
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
        present(LoginPasswordViewController(password: { [unowned self] (pass) in
            do {
                if pass.sha512().sha512() != user.passwordHash {
                    throw EssentiaError.wrongPassword
                }
                let userStore: UserStorageServiceInterface = try RealmUserStorage(seedHash: user.id, password: pass)
                prepareInjection(userStore, memoryPolicy: ObjectScope.viewController)
                (inject() as UserStorageServiceInterface).update { (user) in
                    EssentiaStore.shared.setUser(user)
                }
            } catch {
                (inject() as LoaderInterface).showError(error.description)
                return false
            }
            self.dismiss(animated: true, completion: { [unowned self] in
                self.showTabBar()
            })
            return true
            }, cancel: { [unowned self] in
                self.dismiss(animated: true)
        }), animated: true)
    }
    
    func didSetUser(user: User) -> Bool {
        let viewUsers = (inject() as ViewUserStorageServiceInterface).users
        let userAlreadyExist = viewUsers.contains(where: { $0.id == user.id })
        guard !userAlreadyExist else {
            EssentiaStore.shared.currentUser = .notSigned
            (inject() as LoaderInterface).showError(EssentiaError.userExist.localizedDescription)
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
        EssentiaLoader.show {
            self.showTabBar()
        }
        (inject() as LoginInteractorInterface).generateNewUser {}
    }
}
