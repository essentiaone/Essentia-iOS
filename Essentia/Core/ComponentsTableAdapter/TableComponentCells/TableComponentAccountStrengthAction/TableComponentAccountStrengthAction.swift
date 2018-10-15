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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        // MARK: - Localized Strings
        titleLabel.text = LS("Settings.AccountStrength.Title")
        descriptionLabel.text = LS("Settings.AccountStrength.Description")
        accountButton.setTitle(LS("Settings.AccountStrength.SecureButton"), for: .normal)
        
        // MARK: - Font
        titleLabel.font = AppFont.bold.withSize(24)
        descriptionLabel.font = AppFont.regular.withSize(14)
        accountButton.titleLabel?.font = AppFont.regular.withSize(15)
        
        // MARK: - Color
        titleLabel.textColor = colorProvider.accountStrengthContainerViewTitles
        descriptionLabel.textColor = colorProvider.accountStrengthContainerViewTitles
        accountButton.setTitleColor(colorProvider.accountStrengthContainerViewButtonTitle, for: .normal)
        backgroundColor = colorProvider.settingsBackgroud
        
        // MARK: - Layer
        containerView.drawShadow(width: 10.0)
        containerView.layer.cornerRadius = 10.00
        accountButton.layer.cornerRadius = 5.0
    }
    
    private var containerViewBackgroud: UIColor {
        switch EssentiaStore.currentUser.backup.securityLevel {
        case 30..<50:
            return colorProvider.accountStrengthContainerViewBackgroudMediumSecure
        case 50..<100:
            return colorProvider.accountStrengthContainerViewBackgroudHightSecure
        default:
            return colorProvider.accountStrengthContainerViewBackgroudLowSecure
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.backgroundColor = containerViewBackgroud
    }
    
    @IBAction func accountAction(_ sender: AnyObject) {
        DispatchQueue.main.async { [weak self] in
            self?.resultAction?()
        }
    }
}
