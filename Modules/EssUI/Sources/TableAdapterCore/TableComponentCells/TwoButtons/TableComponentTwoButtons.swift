//
//  TableComponentTwoButtons.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/15/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentTwoButtons: UITableViewCell, NibLoadable {
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    var lAction: (() -> Void)?
    var rAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        leftButton.backgroundColor = .clear
        rightButton.backgroundColor = .clear
        backgroundColor = .clear
        
        leftButton.titleLabel?.font = AppFont.bold.withSize(15)
        rightButton.titleLabel?.font = AppFont.bold.withSize(15)
    }
    
    @IBAction func leftAction(_ sender: Any) {
        lAction?()
    }
    
    @IBAction func rightAction(_ sender: Any) {
        rAction?()
    }
}
