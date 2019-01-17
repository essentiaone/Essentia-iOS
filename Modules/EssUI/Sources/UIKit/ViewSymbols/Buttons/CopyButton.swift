//
//  CopyButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

open class CopyButton: BaseButton {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        setColor()
        showsTouchWhenHighlighted = false
        setFont()
    }
    
    override open var isSelected: Bool {
        didSet {
            isSelected ? setSelectedState() : setDeselectedState()
        }
    }
    
    func setColor() {
        setTitleColor(colorProvider.copyButtonTextColor, for: .normal)
    }
    
    func setSelectedState() {
        backgroundColor = colorProvider.copyButtonBackgroundSelectedColor
    }
    
    func setDeselectedState() {
        backgroundColor = colorProvider.copyButtonBackgroundDeselectedColor
    }
}
