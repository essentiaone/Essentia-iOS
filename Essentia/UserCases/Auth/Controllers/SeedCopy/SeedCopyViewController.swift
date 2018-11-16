//
//  SeedCopyViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SeedCopyViewController: BaseViewController, UITextViewDelegate {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var continueButton: CenteredButton!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var continueButtomConstraint: NSLayoutConstraint!
    
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    let authType: AuthType
    
    // MARK: - Init
    required init(_ auth: AuthType) {
        authType = auth
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
        textView.delegate = self
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    @IBAction func copyAction(_ sender: Any) {
        copyButton.isSelected = true
        continueButton.isEnabled = true
        UIPasteboard.general.string = EssentiaStore.shared.currentUser.seed
    }
    
    @IBAction func continueAction(_ sender: Any) {
        switch authType {
        case .backup:
            EssentiaStore.shared.currentUser.backup.currentlyBackedUp.insert(.seed)
            (inject() as UserStorageServiceInterface).storeCurrentUser()
            (inject() as AuthRouterInterface).showNext()
        case .login:
            let user = User(seed: textView.text)
            EssentiaStore.shared.setUser(user)
            (inject() as AuthRouterInterface).showPrev()
        }

    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidChange(_ textView: UITextView) {
        if authType == .login {
            let continueEnable = textView.text.count == 128
            continueButton.isEnabled = continueEnable
        }
    }
}
