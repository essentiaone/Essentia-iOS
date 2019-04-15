//
//  TableComponentImageTitle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 27.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentImageTitle: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    
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
