//
//  CenteredButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class CenteredButton: BaseButton {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        setFont()
        setTextColor()
    }
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnabled() : setDisabled()
        }
    }
    
    private func setTextColor() {
        setTitleColor(colorProvider.centeredButtonTextColor, for: .normal)
        backgroundColor = colorProvider.centeredButtonBackgroudColor
    }
    
    private func setDisabled() {
        backgroundColor = colorProvider.centeredButtonDisabledBackgroudColor
    }
    
    private func setEnabled() {
        backgroundColor = colorProvider.centeredButtonBackgroudColor
    }
}
