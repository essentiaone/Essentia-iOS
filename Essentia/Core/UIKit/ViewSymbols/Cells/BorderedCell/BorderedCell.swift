//
//  BorderedCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class BorderedCell: BaseCollectionViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawCornerRadius()
        drawBorder()
    }
}
