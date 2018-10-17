//
//  TableComponentBalanceChanging.swift
//  Essentia
//
//  Created by Pavlo Boiko on 18.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentBalanceChanging: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var procentTitle: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var timeUpdateLabel: UILabel!
    var status: ComponentStatus = .idle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        self.procentTitle.font = AppFont.regular.withSize(17)
        self.timeUpdateLabel.font = AppFont.regular.withSize(17)
        self.timeUpdateLabel.textColor = colorProvider.appDefaultTextColor
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setProcentTitleColor()
    }
    
    private func setProcentTitleColor() {
        switch procentTitle.text?.first {
        case "0":
            procentTitle.textColor = colorProvider.balanceChanged
        case "-":
            procentTitle.textColor = colorProvider.balanceChangedMinus
        default:
            procentTitle.textColor = colorProvider.balanceChangedPlus
        }
    }
}
