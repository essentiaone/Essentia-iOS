//
//  TableComponentSectionTitle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 28.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentSectionTitle: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleLabel.font = AppFont.regular.withSize(13)
        titleLabel.textColor = (inject() as AppColorInterface).titleColor
    }
}
