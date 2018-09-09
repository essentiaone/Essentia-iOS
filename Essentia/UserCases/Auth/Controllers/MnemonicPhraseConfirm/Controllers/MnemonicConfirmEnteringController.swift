//
//  MnemonicConfirmEnteringController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Constants {
    static var confirmationNeeded: Int = 4
}

class MnemonicConfirmEnteringController: NSObject, MnemonicPhraseConfirmViewControllerInterface {
    private let mnemonic: [String]
    private var views: [PhraseEnteringViewProtocol?] = []
    private var state: [PhraseEnteringState]
    private var editingIndex: Int = -1
    private var enteredWordCount: Int = 0
    
    // MARK: - Depenences
    weak var delegate: PhraseEnteringControllerDelegate?
    private lazy var mnemonicProvider: MnemonicServiceInterface = inject()
    
    // MARK: - Init
    init(delegate: PhraseEnteringControllerDelegate, mnemonic: String) {
        self.mnemonic = mnemonic.components(separatedBy: " ")
        self.state = Array(repeating: .empty, count: self.mnemonic.count)
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - State
    func updateState() {
        views.forEach {
            $0?.updateState(state: state)
        }
    }
    
    var currentWord: String {
        return mnemonic[editingIndex]
    }
    
    // MARK: - MnemonicPhraseConfirmViewControllerInterface
    func beginEntering() {
        choseNewIndexIfNeeded()
    }
    
    func setViews(_ views: [PhraseEnteringViewProtocol?]) {
        self.views = views
    }
    
    // MARK: - WordCalculating
    func choseNewIndexIfNeeded() {
        guard enteredWordCount < Constants.confirmationNeeded else {
            delegate?.didFinishConfirmingWords(mnemonic: mnemonic)
            return
        }
        confirmNewWord()
        delegate?.didBeginConfirming(word: currentWord, at: editingIndex)
        updateState()
    }
    
    func placeholder(for string: String) -> String {
        guard !string.isEmpty else {
            return ""
        }
        let word = mnemonicProvider.wordList().first {
            return $0.starts(with: string)
        }
        return word ?? ""
    }
    
    private func confirmNewWord() {
        let randomIndex = Int(arc4random()) % mnemonic.count
        let isMaxWordEntered = !state.contains(.empty)
        let isRandomStateEmpty = state[randomIndex] == .empty
        if !isRandomStateEmpty && !isMaxWordEntered {
            confirmNewWord()
        }
        editingIndex = randomIndex
        state[randomIndex] = .entering(word: "", placeholder: "", editingIndex: enteredWordCount)
    }
    
    // MARK: - FakeTextFieldDelegate
    func didEnterCharacter(_ character: String) {
        let oldWord = state[editingIndex].word
        if oldWord.isEmpty && character == "" {
            return
        }
        let lastEditingWord = formateWordWithNewCharacter(oldWord: oldWord, character)
        let fullPlaceholder: String = placeholder(for: lastEditingWord)
        let cuttedPlacehoder =  String(fullPlaceholder.dropFirst(lastEditingWord.count))
        switch lastEditingWord {
        case currentWord:
            state[editingIndex] = .entered(lastEditingWord, editingIndex: enteredWordCount)
            enteredWordCount++
            choseNewIndexIfNeeded()
        default:
            state[editingIndex] = .entering(word: lastEditingWord,
                                            placeholder: cuttedPlacehoder,
                                            editingIndex: enteredWordCount)
        }
        updateState()
    }
    
    func formateWordWithNewCharacter(oldWord: String, _ character: String) -> String {
        var lastEditingWord = oldWord
        switch character {
        case "":
            _ = lastEditingWord.removeLast()
        default:
            guard canEnterCharacter else {
                return oldWord
            }
            lastEditingWord.append(character)
        }
        return lastEditingWord
    }
    
    var canEnterCharacter: Bool {
        return true
    }
}
