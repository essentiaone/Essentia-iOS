//
//  TableComponentTitleSubtileDescription.swift
//  Essentia
//
//  Created by Pavlo Boiko on 9/28/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentTitleSubtileDescription: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtileLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleLabel.font = AppFont.regular.withSize(16)
        subtileLabel.font = AppFont.regular.withSize(14)
        descriptionLabel.font = AppFont.regular.withSize(14)
        
        titleLabel.textColor = colorProvider.settingsMenuTitle
        subtileLabel.textColor = colorProvider.settingsMenuSubtitle
        descriptionLabel.textColor = colorProvider.settingsMenuSubtitle
    }
}
