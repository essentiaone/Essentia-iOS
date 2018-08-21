//
//  TableComponentCheckBox.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentCheckBox: UITableViewCell, NibLoadable {
    @IBOutlet weak var checkBoxImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Dependences
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    func setAttributesTitle(regularPrefix: String, attributedSuffix: String) {
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(
            NSAttributedString(string: regularPrefix,
                               attributes: [NSAttributedStringKey.font: AppFont.regular.withSize(18)]))
        mutableAttributedString.append(NSAttributedString(string: " "))
        mutableAttributedString.append(
            NSAttributedString(string: attributedSuffix,
                               attributes: [NSAttributedStringKey.font: AppFont.bold.withSize(18)]))
        titleLabel.attributedText = mutableAttributedString
        
    }
    
    private func applyDesign() {
        titleLabel.textColor = colorProvider.settingsMenuTitle
        descriptionLabel.textColor = colorProvider.settingsMenuSubtitle
        
        descriptionLabel.font = AppFont.regular.withSize(14)
    }
}
