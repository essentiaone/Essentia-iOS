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
        setColor()
        showsTouchWhenHighlighted = false
        setFont()
    }
    
    override var isSelected: Bool {
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
