//
//  CopyButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class CopyButton: BaseButton {
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        setFont()
    }
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnableState() : setDisableState()
        }
    }
    
    func setEnableState() {
        backgroundColor = .blue
    }
    
    func setDisableState() {
        backgroundColor = .gray
    }
}
