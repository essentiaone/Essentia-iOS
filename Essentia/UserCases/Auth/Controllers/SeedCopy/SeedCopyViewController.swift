//
//  SeedCopyViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssUI
import EssDI

class SeedCopyViewController: BaseViewController, UITextViewDelegate, SwipeableNavigation {
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
    private weak var delegate: SelectAccountDelegate?
    
    // MARK: - Init
    required init(_ auth: AuthType, delegate: SelectAccountDelegate) {
        authType = auth
        self.delegate = delegate
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
        TopAlert(alertType: .info, title: "Seed сopied", inView: self.view).show()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        switch authType {
        case .backup:
            (inject() as UserStorageServiceInterface).update({ (user) in
                user.backup?.currentlyBackup?.add(.seed)
            })
            (inject() as AuthRouterInterface).showNext()
        case .login:
            let user = User(seed: textView.text)
            EssentiaStore.shared.setUser(user)
            (inject() as AuthRouterInterface).showPrev()
            delegate?.didSetUser()
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
