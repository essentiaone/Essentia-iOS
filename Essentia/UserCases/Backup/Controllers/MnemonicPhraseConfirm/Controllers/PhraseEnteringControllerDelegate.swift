//
//  PhraseEnteringControllerDelegate.swift
//  Essentia
//
//  Created by Pavlo Boiko on 04.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol PhraseEnteringControllerDelegate: class {
    func didBeginConfirming(word: String, at index: Int)
    func didFinishConfirmingWords()
}
