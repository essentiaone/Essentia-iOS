//
//  MnemonicLoginController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 30.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssDI

fileprivate struct Constants {
    static var confirmationNeeded: Int = 12
}

class  MnemonicLoginController: NSObject, MnemonicPhraseConfirmViewControllerInterface {
    private var mnemonic: [String] = []
    private var views: [PhraseEnteringViewProtocol?] = []
    private var state: [PhraseEnteringState]
    
    // MARK: - Depenences
    weak var delegate: PhraseEnteringControllerDelegate?
    private lazy var mnemonicProvider: MnemonicServiceInterface = inject()
    
    // MARK: - Init
    init(delegate: PhraseEnteringControllerDelegate) {
        self.state = Array(repeating: .empty, count: Constants.confirmationNeeded)
        self.delegate = delegate
        super.init()
    }
    
    // MARK: - State
    func updateState() {
        views.forEach {
            $0?.updateState(state: state)
        }
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
        guard mnemonic.count < Constants.confirmationNeeded else {
            delegate?.didFinishConfirmingWords(mnemonic: mnemonic)
            return
        }
        confirmNewWord()
        updateState()
    }
    
    func placeholder(for string: String) -> String {
        guard !string.isEmpty else { return "" }
        let word = mnemonicProvider.wordList().first {
            return $0.starts(with: string)
        }
        return word ?? ""
    }
    
    private func confirmNewWord() {
        state[mnemonic.count] = .entering(word: "", placeholder: "", editingIndex: mnemonic.count)
    }
    
    // MARK: - FakeTextFieldDelegate
    func didEnterCharacter(_ character: String) {
        let oldWord = state[mnemonic.count].word
        
        let userWantToEnditPrevWord = oldWord.isEmpty && character == ""
        if userWantToEnditPrevWord && mnemonic.isEmpty { return }
        if userWantToEnditPrevWord {
            editPrevWord()
            return
        }
        
        let newSimbolIsSpace = character == " "
        let lastEditingWord = formateWordWithNewCharacter(oldWord: oldWord, character)
        let searchString = newSimbolIsSpace ? oldWord : lastEditingWord
        let fullPlaceholder: String = placeholder(for: searchString)
        let cuttedPlacehoder =  String(fullPlaceholder.dropFirst(lastEditingWord.count))
        let enteredWordFromDictionary = oldWord == fullPlaceholder
        let isEmptyWord = lastEditingWord.isEmpty || lastEditingWord == " "
        
        if enteredWordFromDictionary && !isEmptyWord && newSimbolIsSpace {
            state[mnemonic.count] = .entered(oldWord, editingIndex: mnemonic.count)
            mnemonic.append(oldWord)
            choseNewIndexIfNeeded()
        } else if character != " " {
            state[mnemonic.count] = .entering(word: lastEditingWord,
                                              placeholder: cuttedPlacehoder,
                                              editingIndex: mnemonic.count)
        }
        updateState()
    }
    
    private func editPrevWord() {
        state[mnemonic.count] = .empty
        mnemonic.removeLast()
        var prevWord = state[mnemonic.count].word
        let lastSimbol = String(prevWord.removeLast())
        state[mnemonic.count] = .entering(word: prevWord,
                                          placeholder: lastSimbol,
                                          editingIndex: mnemonic.count)
        updateState()
    }
    
    private func formateWordWithNewCharacter(oldWord: String, _ character: String) -> String {
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
