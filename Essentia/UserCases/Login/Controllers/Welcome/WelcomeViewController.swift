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

class WelcomeViewController: BaseViewController, RestoreAccountDelegate, SelectAccountDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enterButton: CenteredButton!
    @IBOutlet weak var termsButton: UIButton!
    
    // MARK: - Dependences
    private lazy var design: LoginDesignInterface = inject()
    private lazy var interactor: LoginInteractorInterface = inject()
    private lazy var userService: ViewUserStorageServiceInterface = inject()
    
    // MARK: - Lifecycle
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        design.applyDesign(to: self)
    }
    
    // MARK: - Actions
    @IBAction func restoreAction(_ sender: Any) {
        present(RestoreAccountViewController(delegate: self), animated: true)
    }
    
    @IBAction func enterAction(_ sender: Any) {
        if userService.get().isEmpty {
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
    func showBackup(type: BackupType) {
        dismiss(animated: true)
        let nvc = UINavigationController()
        nvc.setNavigationBarHidden(true, animated: false)
        self.present(nvc, animated: true)
        prepareInjection(AuthRouter(navigationController: nvc,
                                    type: type,
                                    auth: .login,
                                    delegate: self) as AuthRouterInterface,
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
    
    func didSetUser() {
        showTabBar()
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
