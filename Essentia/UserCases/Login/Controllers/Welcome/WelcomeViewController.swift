//
//  WelcomeViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class WelcomeViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var restoreButton: UIButton!
    @IBOutlet weak var title1Label: UILabel!
    @IBOutlet weak var title2Label: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var enterButton: CenteredButton!
    @IBOutlet weak var termsButton: UIButton!
    
    // MARK: - Dependences
    private lazy var design: LoginDesignInterface = inject()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        design.applyDesign(to: self)
    }
    
    // MARK: - Actions
    @IBAction func restoreAction(_ sender: Any) {
    }
    
    @IBAction func enterAction(_ sender: Any) {
        let mnemonic: String = MnemonicProvider(language: .english).mnemonic
        prepareInjection(
            BackupRouter(rootController: self, mnemonic: mnemonic, type: .seed) as BackupRouterInterface,
            memoryPolicy: .viewController
        )
    }
    
    @IBAction func termsAction(_ sender: Any) {
    }
    
}
