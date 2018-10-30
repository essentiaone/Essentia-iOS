//
//  TableComponentTransaction.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentTransaction: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtileLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleLabel.font = AppFont.regular.withSize(14)
        subtileLabel.font = AppFont.bold.withSize(14)
        descriptionLabel.font = AppFont.regular.withSize(15)
        
        subtileLabel.lineBreakMode = .byTruncatingMiddle
        titleLabel.textColor = colorProvider.settingsMenuSubtitle
        subtileLabel.textColor = colorProvider.settingsMenuTitle
    }
}
