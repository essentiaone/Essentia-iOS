//
//  BaseCollectionViewCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

fileprivate struct Constants {
    static var cornerRadius: CGFloat = 5.0
    static var borderWidth: CGFloat = 1.0
}

open class BaseCollectionViewCell: UICollectionViewCell {
    private lazy var colorProvider: AppColorInterface = inject()
    
    public func drawCornerRadius() {
        layer.cornerRadius = Constants.cornerRadius
    }
    
    public func drawBorder() {
        layer.borderColor = colorProvider.borderedButtonBorderColor.cgColor
        layer.borderWidth = Constants.borderWidth
    }
}
