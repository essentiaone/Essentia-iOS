//
//  AmmountEnteringDelegate.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit

fileprivate struct Default {
    static let separator = "."
    static let digitsAfterComma = 18
    static let amountMaxLength = 28
}

public class AmmountEnteringDelegate: NSObject, UITextFieldDelegate {
    
    private var enteredAmount: String
    public var doneAction: (String) -> Void
    
    public init(_ doneAction: @escaping (String) -> Void, currentState: String, textField: UITextField) {
        self.doneAction = doneAction
        enteredAmount = currentState
        super.init()
        textField.addTarget(self, action: #selector(textFieldEditingChanged(sender:)), for: .editingChanged)
    }
    
    // MARK: - UITextFieldDelegate
    
    public func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = enteredAmount
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
        let zeroValues = ["0", "0.0", "0.00"]
        guard let text = textField.text, !zeroValues.contains(text) else {
            enteredAmount = ""
            textField.text = ""
            doneAction(enteredAmount)
            return
        }
        enteredAmount = text
        doneAction(text)
    }
    
    @objc
    private func textFieldEditingChanged(sender: UITextField) {
        let currectPosition = sender.selectedTextRange
        sender.text = sender.text?.replacing(charactersIn: EssCharacters.ammountSeparators.set, with: Default.separator)
        sender.selectedTextRange = currectPosition
        doneAction(sender.text ?? "")
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let newCharacter = string
        let ammountField = textField.text ?? ""
        if newCharacter.isEmpty && !ammountField.isEmpty { return true }
        
        let ammountLength = ammountField.count
        let newStringLenght = string.count
        let cursorPosition = range.location
        let ammountContainSeparator = ammountField.contains(charactersIn: EssCharacters.ammountSeparators.set)
        let isSeparator = newCharacter.contains(charactersIn: EssCharacters.ammountSeparators.set)
        let isPosibleLocationToPasteSeparator = cursorPosition < ammountLength - Default.digitsAfterComma
        let separatorLocationIfExist = ammountField.coincidencesIndexes(with: EssCharacters.ammountSeparators.set).first ?? 0
        let isAllDigitsAfterSeparatorEntered =  ammountLength - separatorLocationIfExist > Default.digitsAfterComma
        let isLocationAfterSeparator = ammountContainSeparator && separatorLocationIfExist < cursorPosition
        
        let separatorAlreadyExistFlag = ammountContainSeparator && isSeparator
        let separatorWrongPositionFlag = !ammountContainSeparator && isSeparator && isPosibleLocationToPasteSeparator
        let digitWrongPositionFlag = ammountContainSeparator && isAllDigitsAfterSeparatorEntered && isLocationAfterSeparator
        let maxSimbolsAmmountFlag = ammountLength + newStringLenght > Default.amountMaxLength
        let wrongNewStringFlag = !isSeparator && Int(newCharacter) == nil
        
        let isAnyErrors = separatorAlreadyExistFlag || separatorWrongPositionFlag || digitWrongPositionFlag || maxSimbolsAmmountFlag || wrongNewStringFlag
        
        return !isAnyErrors
    }
    
}
