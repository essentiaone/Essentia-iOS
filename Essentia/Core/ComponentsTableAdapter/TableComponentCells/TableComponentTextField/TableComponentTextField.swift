//
//  TableComponentTextField.swift
//  Essentia
//
//  Created by Pavlo Boiko on 30.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentTextField: UITableViewCell, NibLoadable, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    var textFieldAction: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        textField.font = AppFont.regular.withSize(14)
        textField.textColor = (inject() as AppColorInterface).appTitleColor
        textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        textField.delegate = self
    }
    
    // MARK: - UITextFieldDelegate
    @objc func textFieldChanged() {
        textFieldAction?(textField.text!)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
}
