//
//  KeyStorePasswordViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class KeyStorePasswordViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var continueButton: CenteredButton!
    
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    
    // MARK: - Store
    let mnemonic: String
    
    // MARK: - Init
    required init(mnemonic: String) {
        self.mnemonic = mnemonic
        super.init()
    }
    
    required override init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        design.applyDesign(to: self)
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as BackupRouterInterface).showPrev()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        (inject() as BackupRouterInterface).showNext()
    }
}
