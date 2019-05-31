//
//  ImageWithRightTitleAndSubtitle.swift
//  EssUI
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentImageRightTitleSubtitle: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var rightTitle: UILabel!
    @IBOutlet weak var rightSubtitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleLabel.font = AppFont.regular.withSize(17)
        titleLabel.textColor = (inject() as AppColorInterface).appTitleColor
        
        titleImage.layer.cornerRadius = 30.0
        titleImage.layer.cornerRadius = titleImage.layer.bounds.width / 2
        titleImage.clipsToBounds = true
        
        rightTitle.font = AppFont.bold.withSize(14)
        rightTitle.textColor = (inject() as AppColorInterface).appTitleColor
        
        rightSubtitle.font = AppFont.medium.withSize(12)
        rightTitle.textColor = (inject() as AppColorInterface).appTitleColor
    }
}
