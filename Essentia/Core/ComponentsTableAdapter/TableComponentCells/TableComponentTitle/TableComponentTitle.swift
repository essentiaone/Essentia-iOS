//
//  TableComponentTitle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentTitle: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.font = AppFont.bold.withSize(34)
        titleLabel.textColor = colorProvider.appTitleColor
    }
}
