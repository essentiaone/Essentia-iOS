//
//  BaseCollectionViewCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var cornerRadius: CGFloat = 5.0
    static var borderWidth: CGFloat = 1.0
}

class BaseCollectionViewCell: UICollectionViewCell {
    private lazy var colorProvider: AppColorInterface = inject()
    
    func drawCornerRadius() {
        layer.cornerRadius = Constants.cornerRadius
    }
    
    func drawBorder() {
        layer.borderColor = colorProvider.borderedButtonBorderColor.cgColor
        layer.borderWidth = Constants.borderWidth
    }
}
