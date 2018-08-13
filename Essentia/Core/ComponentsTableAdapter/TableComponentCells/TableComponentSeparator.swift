//
//  TableComponentSeparator.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentSeparator: UITableViewCell {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = colorProvider.separatorBackgroundColor
    }
    
}
