//
//  TableComponentTextFieldDetail.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/2/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI

class TableComponentTextFieldDetail: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    var enteringDelegate: AmmountEnteringDelegate?
    
    var enterAction: ((String) -> Void)? {
        didSet {
            guard let enterAction = enterAction else { return }
            enteringDelegate = AmmountEnteringDelegate(enterAction, currentState: titleTextField.text ?? "0", textField: titleTextField)
            titleTextField.delegate = enteringDelegate
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleTextField.isUserInteractionEnabled = false
    }
}
