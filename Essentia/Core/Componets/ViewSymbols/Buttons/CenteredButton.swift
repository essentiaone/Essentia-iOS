//
//  CenteredButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class CenteredButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        drawLayout()
    }
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnableState() : setDisableState()
        }
    }
    
    func drawLayout() {
        layer.cornerRadius = 5.0
        isEnabled = true
    }
    
    func setEnableState() {
        backgroundColor = .blue
    }
    
    func setDisableState() {
        backgroundColor = .gray
    }
}
