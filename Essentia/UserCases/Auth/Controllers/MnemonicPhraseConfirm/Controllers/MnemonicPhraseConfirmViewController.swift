//
//  MnemonicPhraseConfirmViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel

class MnemonicPhraseConfirmViewController: BaseViewController, PhraseEnteringControllerDelegate, SwipeableNavigation {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: BackButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var currentWordLabel: UILabel!
    @IBOutlet weak var confirmWordsCollectionView: UICollectionView!
    @IBOutlet weak var currentWordCollectionView: UICollectionView!
    @IBOutlet weak var fakeTextField: FakeTextField!
    @IBOutlet weak var phraseEnteringViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttomCurrentWordConstraint: NSLayoutConstraint!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Dependences
    private lazy var design: BackupDesignInterface = inject()
    private lazy var wordIndicator = CurrentWordIndicatorAdapter(collectionView: currentWordCollectionView)
    private lazy var wordEntering = PhraseConfirmCollectionViewAdapter(collectionView: confirmWordsCollectionView)
    private var phraseEnteingController: MnemonicPhraseConfirmViewControllerInterface?
    let authType: AuthType
    private weak var delegate: SelectAccountDelegate?
    
    // MARK: - Init
    init(mnemonic: String) {
        authType = .backup
        super.init()
        phraseEnteingController = MnemonicConfirmEnteringController(delegate: self,
                                                                    mnemonic: mnemonic)
    }
    
    init(delegate: SelectAccountDelegate) {
        self.delegate = delegate
        authType = .login
        super.init()
        phraseEnteingController = MnemonicLoginController(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.checkPasteboard()
            self.buttomCurrentWordConstraint.constant = newValue + 8
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        design.applyDesign(to: self)
        phraseEnteingController?.setViews([wordEntering, wordIndicator])
        setupFakeTextField()
        setupPhraseEnteringController()
        checkPasteboard()
    }
    
    private func setupPhraseEnteringController() {
        phraseEnteingController?.beginEntering()
    }
    
    private func setupFakeTextField() {
        fakeTextField.fakeDelegate = phraseEnteingController
        fakeTextField.becomeFirstResponder()
    }

    private func checkPasteboard() {
        guard let pasteboardString = UIPasteboard.general.string else { return }
        let isMnemonic = pasteboardString.split(separator: " ").count == 12
        if isMnemonic {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 45))
            button.setTitle(pasteboardString, for: .normal)
            button.backgroundColor = .lightGray
            fakeTextField.inputAccessoryView = button
            button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        } else {
            fakeTextField.inputAccessoryView = UIView()
        }
    }
    
    @objc func buttonAction(sender: UIButton!) {
        guard let pasteboardString = sender.titleLabel?.text else { return }
        (inject() as LoaderInterface).show()
        let mnemonic = pasteboardString.split(separator: " ").map { return String(describing: $0) }
        didFinishConfirmingWords(mnemonic: mnemonic)
        (inject() as LoaderInterface).hide()
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    // MARK: - PhraseEnteringControllerDelegate
    
    func didFinishConfirmingWords(mnemonic: [String]) {
        switch authType {
        case .backup:
            EssentiaStore.shared.currentUser.backup.currentlyBackedUp.insert(.mnemonic)
            storeCurrentUser()
            (inject() as AuthRouterInterface).showNext()
        case .login:
            let mnemonic = mnemonic.joined(separator: " ")
            let user = User(mnemonic: mnemonic)
            try? EssentiaStore.shared.setUser(user, password: User.defaultPassword)
            (inject() as AuthRouterInterface).showPrev()
            delegate?.didSetUser()
        }
    }
    
    func didBeginConfirming(word: String, at index: Int) {
        currentWordLabel.text = "\(index + 1)\(LS("MnemonicPhraseConfirm.CurrentWord"))"
    }
}
