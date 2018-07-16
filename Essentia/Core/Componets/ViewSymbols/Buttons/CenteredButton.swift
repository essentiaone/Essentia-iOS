//
//  CenteredButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class CenteredButton: BaseButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        setFont()
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setSelected() : setDeseleted()
        }
    }
    
    func setSelected() {
        backgroundColor = .green
    }
    
    func setDeseleted() {
        backgroundColor = .blue
    }
}
