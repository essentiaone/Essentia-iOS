//
//  BorderedCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

open class BorderedCell: BaseCollectionViewCell, NibLoadable {
    @IBOutlet public weak var titleLabel: UILabel!
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        drawBorder()
    }
}
