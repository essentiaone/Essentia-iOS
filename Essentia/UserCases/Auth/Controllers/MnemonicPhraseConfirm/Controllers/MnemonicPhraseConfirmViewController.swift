//
//  MnemonicPhraseConfirmViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 23.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class MnemonicPhraseConfirmViewController: BaseViewController, PhraseEnteringControllerDelegate {
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
    
    // MARK: - Init
    required init(mnemonic: String) {
        authType = .backup
        super.init()
        phraseEnteingController = MnemonicConfirmEnteringController(delegate: self,
                                                                    mnemonic: mnemonic)
    }
    
    override init() {
        authType = .login
        super.init()
        phraseEnteingController = MnemonicLoginController(delegate: self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        design.applyDesign(to: self)
        phraseEnteingController?.setViews([wordEntering, wordIndicator])
        setupFakeTextField()
        setupPhraseEnteringController()
        
    }
    
    private func setupPhraseEnteringController() {
        phraseEnteingController?.beginEntering()
    }
    
    private func setupFakeTextField() {
        fakeTextField.fakeDelegate = phraseEnteingController
        fakeTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    // MARK: - PhraseEnteringControllerDelegate
    
    func didFinishConfirmingWords(mnemonic: [String]) {
        switch authType {
        case .backup:
            EssentiaStore.currentUser.backup.currentlyBackedUp.append(.mnemonic)
            (inject() as AuthRouterInterface).showNext()
        case .login:
            let mnemonic = mnemonic.joined(separator: " ")
            EssentiaStore.currentUser = User(mnemonic: mnemonic)
            (inject() as AuthRouterInterface).showPrev()
        }
    }
    
    func didBeginConfirming(word: String, at index: Int) {
        currentWordLabel.text = "\(index + 1)\(LS("MnemonicPhraseConfirm.CurrentWord"))"
    }
}
