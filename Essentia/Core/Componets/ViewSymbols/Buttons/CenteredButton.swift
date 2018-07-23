//
//  CenteredButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class CenteredButton: BaseButton {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        setFont()
        setTextColor()
        drawShadow(width: 5.0)
    }
    
    override var isEnabled: Bool {
        didSet {
            isEnabled ? setEnabled() : setDisable()
        }
    }
    
    private func setTextColor() {
        setTitleColor(colorProvider.centeredButtonTextColor, for: .normal)
        backgroundColor = colorProvider.centeredButtonBackgroudColor
    }
    
    private func setDisable() {
        backgroundColor = colorProvider.centeredButtonDisabledBackgroudColor
        drawShadow(width: 5.0)
    }
    
    private func setEnabled() {
        backgroundColor = colorProvider.centeredButtonBackgroudColor
        drawShadow(width: 5.0)
    }
}
