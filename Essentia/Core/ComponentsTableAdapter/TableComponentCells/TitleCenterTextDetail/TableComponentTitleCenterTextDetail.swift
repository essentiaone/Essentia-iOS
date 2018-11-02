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
    @IBOutlet weak var detailTextField: UITextField!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var textFieldConstraint: NSLayoutConstraint!
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    @IBAction func buttonAction(_ sender: Any) {
        action?()
    }
}
