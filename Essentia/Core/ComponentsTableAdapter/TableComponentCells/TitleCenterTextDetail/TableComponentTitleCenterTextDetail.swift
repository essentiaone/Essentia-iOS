//
//  TableComponentTitleCenterTextDetail.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentTitleCenterTextDetail: UITableViewCell, NibLoadable {
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
        centeredTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ notification: NSNotification) {
        let text = centeredTextField.text ?? ""
        let hideButton = !text.isEmpty
        enterAction?(text)
        rightButton.isHidden = hideButton
        textFieldConstraint.constant = hideButton ? 10.0 : 42.0
    }
}
