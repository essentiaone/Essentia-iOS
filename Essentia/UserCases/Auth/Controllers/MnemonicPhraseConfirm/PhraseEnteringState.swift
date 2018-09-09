//
//  PhraseEnteringState.swift
//  Essentia
//
//  Created by Pavlo Boiko on 03.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

protocol PhraseEnteringViewProtocol {
    func updateState(state: [PhraseEnteringState])
}

enum PhraseEnteringState: Equatable {
    case empty
    case entered(String, editingIndex: Int)
    case entering(word: String, placeholder: String, editingIndex: Int)
    
    var word: String {
        switch self {
        case .entered(let word, _):
            return word
        case .entering(let word, _, _):
            return word
        default:
            return ""
        }
    }
    
    var sortValue: Int {
        switch self {
        case .entered(_, let value):
            return value
        case .entering(_, _, let value):
            return value
        default:
            return -1
        }
    }
    
    public static func==(lhs: PhraseEnteringState, rhs: PhraseEnteringState) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    var rawValue: String {
        return String(describing: self)
    }
}
