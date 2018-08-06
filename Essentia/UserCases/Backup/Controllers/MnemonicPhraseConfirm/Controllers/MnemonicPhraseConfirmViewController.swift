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
    
    // MARK: - Dependences
    private let mnemonic: String
    private lazy var design: BackupDesignInterface = inject()
    private lazy var wordIndicator = CurrentWordIndicatorAdapter(collectionView: currentWordCollectionView)
    private lazy var wordEntering = PhraseConfirmCollectionViewAdapter(collectionView: confirmWordsCollectionView)
    private lazy var phraseEnteingController = PhraseEnteringController(mnemonic: mnemonic,
                                                                        views: [wordEntering, wordIndicator])
    
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
    
    // MARK: - LifeCycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        design.applyDesign(to: self)
        setupFakeTextField()
        setupPhraseEnteringController()
    }
    
    private func setupPhraseEnteringController() {
        phraseEnteingController.delegate = self
        phraseEnteingController.choseNewIndexIfNeeded()
    }
    
    private func setupFakeTextField() {
        fakeTextField.fakeDelegate = phraseEnteingController
        fakeTextField.becomeFirstResponder()
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as BackupRouterInterface).showPrev()
    }
    
    // MARK: - PhraseEnteringControllerDelegate
    
    func didFinishConfirmingWords() {
//        (inject() as BackupRouterInterface).()
    }
    
    func didBeginConfirming(word: String, at index: Int) {
        currentWordLabel.text = "\(index + 1)\(LS("MnemonicPhraseConfirm.CurrentWord"))"
    }
}
