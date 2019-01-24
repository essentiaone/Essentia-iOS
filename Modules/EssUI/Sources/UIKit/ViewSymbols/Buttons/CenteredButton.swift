//
//  CenteredButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

open class CenteredButton: BaseButton {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        setFont()
        setTextColor()
    }
    
    override open var isEnabled: Bool {
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
