//
//  TableComponentAccountStrengthAction.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

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
        setButtonTitle()
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.updateProgress()
        self.setButtonTitle()
    }
    
    private func updateProgress() {
        let newUser = EssentiaStore.shared.currentUser
        let animation = animationForSecurirtyLevel(newUser.backup.secureLevel)
        let player = PNGAnimationPlayer(animation: animation, in: progressImageView)
        let shoudShowAnimation = currentSecurity != newUser.backup.secureLevel && currentUserId == newUser.id
        currentUserId = newUser.id
        currentSecurity = newUser.backup.secureLevel
        guard shoudShowAnimation else {
            progressImageView.image = defaultImageForAnimationPlayer(player, for: newUser.backup.secureLevel)
            containerView.backgroundColor = colorForCurrentSecuringStatus
            return
        }
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.4) {
            self.setButtonTitle()
            self.playAnimation(in: player)
        }
    }
    
    func playAnimation(in player: PNGAnimationPlayer) {
        containerView.animateToColor(colorForCurrentSecuringStatus, with: player.animation.animationDuration)
        player.play()
    }
    
    private func setButtonTitle() {
        titleLabel.text = LS("Settings.AccountStrength.Title")
        descriptionLabel.text = LS("Settings.AccountStrength.Description")
        switch EssentiaStore.shared.currentUser.backup.secureLevel {
        case 3:
            accountButton.setTitle(LS("Settings.AccountStrength.Push"), for: .normal)
        default:
            accountButton.setTitle(LS("Settings.AccountStrength.SecureButton"), for: .normal)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func accountAction(_ sender: AnyObject) {
        switch EssentiaStore.shared.currentUser.backup.secureLevel {
        case 3:
            (inject() as SettingsRouterInterface).show(.fullSecured)
        default:
            self.resultAction?()
        }
    }
}
