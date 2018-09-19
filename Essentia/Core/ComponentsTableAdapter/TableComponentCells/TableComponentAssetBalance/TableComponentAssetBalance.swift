//
//  TableComponentAssetBalance.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentAssetBalance: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var balanceTopValue: UILabel!
    @IBOutlet weak var balanceButtomValue: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        let colorProvider: AppColorInterface = inject()
        titleImage.layer.cornerRadius = 30.0
        titleLabel.font = AppFont.medium.withSize(17)
        titleLabel.textColor = colorProvider.appTitleColor
        balanceTopValue.textColor = colorProvider.appTitleColor
        balanceButtomValue.textColor = colorProvider.appDefaultTextColor
        balanceTopValue.font = AppFont.bold.withSize(15)
        balanceButtomValue.font = AppFont.regular.withSize(14)
    }
}
