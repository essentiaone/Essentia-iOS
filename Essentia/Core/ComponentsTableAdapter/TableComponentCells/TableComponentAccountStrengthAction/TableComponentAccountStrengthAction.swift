//
//  TableComponentAccountStrengthAction.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentAccountStrengthAction: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var accountButton: UIButton!
    
    var resultAction: (() -> Void)?
    var progress: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        // MARK: - Localized Strings
        titleLabel.text = LS("Settings.AccountStrength.Title")
        descriptionLabel.text = LS("Settings.AccountStrength.Description")
        accountButton.setTitle(LS("Settings.AccountStrength.SequreButton"), for: .normal)
        
        // MARK: - Font
        titleLabel.font = AppFont.bold.withSize(24)
        descriptionLabel.font = AppFont.regular.withSize(14)
        accountButton.titleLabel?.font = AppFont.regular.withSize(15)
        
        // MARK: - Color
        containerView.backgroundColor = colorProvider.accountStrengthContainerViewBackgroud
        titleLabel.textColor = colorProvider.accountStrengthContainerViewTitles
        descriptionLabel.textColor = colorProvider.accountStrengthContainerViewTitles
        accountButton.setTitleColor(colorProvider.accountStrengthContainerViewButtonTitle, for: .normal)
        backgroundColor = colorProvider.settingsBackgroud
        
        // MARK: - Layer
        containerView.drawShadow(width: 10.0)
        containerView.layer.cornerRadius = 10.00
        accountButton.layer.cornerRadius = 5.0
    }
    
    @IBAction func accountAction(_ sender: AnyObject) {
        resultAction?()
    }
}
