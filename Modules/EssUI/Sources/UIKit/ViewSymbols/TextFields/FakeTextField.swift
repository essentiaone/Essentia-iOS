//
//  FakeTextField.swift
//  Essentia
//
//  Created by Pavlo Boiko on 26.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public protocol FakeTextFieldDelegate: NSObjectProtocol {
    func didEnterCharacter(_ character: String)
}

open class FakeTextField: UITextField, UITextFieldDelegate {
    public weak var fakeDelegate: FakeTextFieldDelegate?
    
    // MARK: - Lifecycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupFakeTextField()
    }
    
    private func setupFakeTextField() {
        becomeFirstResponder()
        autocorrectionType = .no
        delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    public func textField
        (
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
        ) -> Bool {
        fakeDelegate?.didEnterCharacter(string)
        return true
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return false
    }
}
