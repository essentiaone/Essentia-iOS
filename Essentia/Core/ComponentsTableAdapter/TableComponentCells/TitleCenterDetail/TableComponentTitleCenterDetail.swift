//
//  TableComponentTitleCenterDetail.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/30/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentTitleCenterDetail: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let colorProvider: AppColorInterface = inject()
        titleLabel.font = AppFont.regular.withSize(17)
        detailLabel.font = AppFont.medium.withSize(17)
        titleLabel.textColor = colorProvider.appTitleColor
        detailLabel.textColor = colorProvider.appTitleColor
    }
}
