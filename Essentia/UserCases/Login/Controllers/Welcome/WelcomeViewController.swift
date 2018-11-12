//
//  WelcomeViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController, RestoreAccountDelegate {
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
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        design.applyDesign(to: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard !EssentiaStore.shared.currentUser.seed.isEmpty else {
            return
        }
        openTabBar()
    }
    
    // MARK: - Actions
    @IBAction func restoreAction(_ sender: Any) {
        present(RestoreAccountViewController(delegate: self), animated: true)
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let switchAccount =  SwitchAccoutViewController { [weak self] in
            self?.openTabBar()
        }
        present(switchAccount, animated: true)
    }
    
    @IBAction func termsAction(_ sender: Any) {
    }
    
    func openTabBar() {
        self.present(TabBarController(), animated: true)
    }
    
    // MARK: - RestoreAccountDelegate
    func showBackup(type: BackupType) {
        dismiss(animated: true)
        let nvc = UINavigationController()
        nvc.setNavigationBarHidden(true, animated: false)
        self.present(nvc, animated: true)
        prepareInjection(AuthRouter(navigationController: nvc,
                                    type: type,
                                    auth: .login) as AuthRouterInterface,
                         memoryPolicy: .viewController)
    }
    
}
