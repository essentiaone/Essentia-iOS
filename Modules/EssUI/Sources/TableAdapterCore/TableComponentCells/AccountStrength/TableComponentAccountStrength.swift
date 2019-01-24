//
//  TableComponentAccountStrength.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentAccountStrength: BaseAccountStrengthCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var iconProvider: AppImageProviderInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var progressImageView: UIImageView!
    
    var resultAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        // MARK: - Localized Strings
        titleLabel.text = LS("Settings.AccountStrength.Title")
        descriptionLabel.text = LS("Settings.AccountStrength.Description")
        backButton.setTitle(LS("Settings.Secure.Back"), for: .normal)
        
        // MARK: - Font
        titleLabel.font = AppFont.bold.withSize(32)
        descriptionLabel.font = AppFont.regular.withSize(15)
        backButton.titleLabel?.font = AppFont.regular.withSize(16)
        
        // MARK: - Color
        titleLabel.textColor = colorProvider.accountStrengthContainerViewTitles
        descriptionLabel.textColor = colorProvider.accountStrengthContainerViewTitles
        backgroundColor = colorProvider.settingsBackgroud
        backButton.titleLabel?.textColor = colorProvider.accountStrengthContainerViewTitles
        backButton.tintColor = colorProvider.accountStrengthContainerViewTitles
        
        // MARK: - Layer
        backButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 15)
        backButton.setImage(iconProvider.backWhiteIcon, for: .normal)
    }
    
    func updateStatus(securityLevel: Int) {
        containerView.backgroundColor = colorFor(securityStatus: securityLevel)
        let animation = animationForSecurirtyLevel(securityLevel)
        let player = PNGAnimationPlayer(animation: animation, in: progressImageView)
        progressImageView.image = defaultImageForAnimationPlayer(player, for: securityLevel)
    }
    
    @IBAction func backAction(_ sender: AnyObject) {
        self.resultAction?()
    }
}
