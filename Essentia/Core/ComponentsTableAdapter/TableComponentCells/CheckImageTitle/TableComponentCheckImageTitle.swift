//
//  TableComponentCheckImageTitle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentCheckImageTitle: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var checkImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleImageView.layer.cornerRadius = 14.0
        checkImageView.layer.cornerRadius = 11.0
        titleImageView.clipsToBounds = true
        titleLabel.font = AppFont.medium.withSize(17)
        titleLabel.textColor = (inject() as AppColorInterface).appTitleColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleImageView.image = nil
    }
}
