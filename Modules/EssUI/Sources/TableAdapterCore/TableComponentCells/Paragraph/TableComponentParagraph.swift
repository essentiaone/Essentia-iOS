//
//  TableComponentParagraph.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

class TableComponentParagraph: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var dotIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleLabel.font = AppFont.bold.withSize(18)
        descriptionLabel.font = AppFont.regular.withSize(17)
        
        titleLabel.textColor = colorProvider.appDefaultTextColor
        titleLabel.textColor = colorProvider.appTitleColor
        dotIcon.image = imageProvider.darkDotIcon
    }
}
