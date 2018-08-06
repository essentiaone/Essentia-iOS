//
//  FakeTextField.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol FakeTextFieldDelegate: NSObjectProtocol {
    func didEnterCharacter(_ character: String)
}

class FakeTextField: UITextField, UITextFieldDelegate {
    weak var fakeDelegate: FakeTextFieldDelegate?
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        setupFakeTextField()
    }
    
    private func setupFakeTextField() {
        becomeFirstResponder()
        autocorrectionType = .no
        delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    func textField
        (
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        fakeDelegate?.didEnterCharacter(string)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
