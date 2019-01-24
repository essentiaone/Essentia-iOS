//
//  TableComponentBalanceChanging.swift
//  Essentia
//
//  Created by Pavlo Boiko on 18.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentBalanceChanging: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    @IBOutlet weak var procentTitle: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    @IBOutlet weak var timeUpdateLabel: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        self.procentTitle.font = AppFont.regular.withSize(17)
        self.timeUpdateLabel.font = AppFont.regular.withSize(17)
        self.timeUpdateLabel.textColor = colorProvider.appDefaultTextColor
        self.updateButton.setImage(imageProvider.loading, for: .normal)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setProcentTitleColor()
    }
    
    private func setProcentTitleColor() {
        switch procentTitle.text?.first {
        case "+":
            procentTitle.textColor = colorProvider.balanceChangedPlus
        case "-":
            procentTitle.textColor = colorProvider.balanceChangedMinus
        default:
            procentTitle.textColor = colorProvider.balanceChanged
        }
    }

    @IBAction func updateAction(_ sender: Any) {
        action?()
    }
}
