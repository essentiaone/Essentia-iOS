//
//  TableComponentImageTitleRightImage.swift
//  EssUI
//
//  Created by Pavlo Boiko on 7/1/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentImageTitleRightImage: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var rightImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleImage.layer.cornerRadius = 30.0
        titleLabel.font = AppFont.medium.withSize(17)
        titleLabel.textColor = (inject() as AppColorInterface).appTitleColor
        titleImage.layer.cornerRadius = titleImage.layer.bounds.width / 2
        titleImage.clipsToBounds = true
    }
}
