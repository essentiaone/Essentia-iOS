//
//  BorderedButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 18.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

open class BorderedButton: BaseButton {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        drawBorder()
        drawText()
        drawCornerRadius()
    }
    
    private func drawText() {
        setTitleColor(colorProvider.borderedButtonTextColor, for: .normal)
        backgroundColor = .clear
    }
    
    private func drawBorder() {
        layer.borderColor = colorProvider.borderedButtonBorderColor.cgColor
        layer.borderWidth = 2
    }
}
