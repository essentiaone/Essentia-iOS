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
    var action: (() -> Void)?
    
    @IBAction func buttonAction(_ sender: Any) {
        action?()
    }
}
