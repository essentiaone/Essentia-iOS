//
//  TableComponentImageTitleSubtitle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/7/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentImageTitleSubtitle: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleImagevView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subltitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    func applyDesign() {
        titleLabel.font = AppFont.medium.withSize(18)
        subltitle.font = AppFont.regular.withSize(14)
        
        titleLabel.textColor = (inject() as AppColorInterface).titleColor
        subltitle.textColor = (inject() as AppColorInterface).appDefaultTextColor
    }
}
