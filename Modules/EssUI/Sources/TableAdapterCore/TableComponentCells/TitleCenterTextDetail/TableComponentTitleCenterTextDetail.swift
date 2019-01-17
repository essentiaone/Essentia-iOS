//
//  TableComponentTitleCenterTextDetail.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentTitleCenterTextDetail: UITableViewCell, NibLoadable, UITextFieldDelegate {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var textFieldConstraint: NSLayoutConstraint!
    @IBOutlet weak var centeredTextField: UITextField!
    
    var enterAction: ((String) -> Void)?
    var action: (() -> Void)?
    
    @IBAction func buttonAction(_ sender: Any) {
        action?()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        centeredTextField.isUserInteractionEnabled = false
        centeredTextField.delegate = self
        centeredTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ notification: NSNotification) {
        let text = centeredTextField.text ?? ""
        updateQrButton(text)
        enterAction?(text)
    }
    
    func updateQrButton(_ text: String) {
        let hideButton = !text.isEmpty
        rightButton.isHidden = hideButton
        rightButton.isUserInteractionEnabled = !hideButton
        textFieldConstraint.constant = hideButton ? 10.0 : 42.0
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.isUserInteractionEnabled = false
    }
}
