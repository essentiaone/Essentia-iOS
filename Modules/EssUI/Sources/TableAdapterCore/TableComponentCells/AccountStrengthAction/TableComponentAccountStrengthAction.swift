//
//  TableComponentAccountStrengthAction.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

class TableComponentAccountStrengthAction: BaseAccountStrengthCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var progressView: UIView!
    @IBOutlet weak var progressImageView: UIImageView!
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
        
        // MARK: - Font
        titleLabel.font = AppFont.bold.withSize(24)
        descriptionLabel.font = AppFont.regular.withSize(14)
        accountButton.titleLabel?.font = AppFont.bold.withSize(15)
        
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
    
    func renderState(state: AnimationState, secureLevel: Int) {
        let animation = animationForSecurirtyLevel(secureLevel)
        let player = PNGAnimationPlayer(animation: animation, in: self.progressImageView)
        switch state {
        case .updating:
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
                self.playAnimation(in: player, to: secureLevel)
            }
        case .idle:
            let nextColor = colorFor(securityStatus: secureLevel)
            progressImageView.image = defaultImageForAnimationPlayer(player, for: secureLevel)
            containerView.backgroundColor = nextColor
        }
        setButtonTitle(secureLevel: secureLevel)
    }
    
    func playAnimation(in player: PNGAnimationPlayer, to secureLevel: Int) {
        let nextColor = colorFor(securityStatus: secureLevel)
        containerView.animateToColor(nextColor, with: player.animation.animationDuration)
        player.play()
    }
    
    func setButtonTitle(secureLevel: Int) {
        titleLabel.text = LS("Settings.AccountStrength.Title")
        descriptionLabel.text = LS("Settings.AccountStrength.Description")
        switch secureLevel {
        case 3:
            accountButton.setTitle(LS("Settings.AccountStrength.Push"), for: .normal)
        default:
            accountButton.setTitle(LS("Settings.AccountStrength.SecureButton"), for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func accountAction(_ sender: AnyObject) {
        self.resultAction?()
    }
}
