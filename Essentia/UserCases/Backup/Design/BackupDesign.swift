//
//  BackupDesign.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class BackupDesign: BackupDesignInterface {
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    func applyDesign(to vc: WarningViewContrller) {
        // MARK: - Localized Strings
        vc.titleLabel.text = LS("Warning.Title")
        vc.descriptionLabel.text = LS("Warning.Description")
        vc.doneButton.setTitle(LS("Warning.Done"), for: .normal)
        
        // MARK: - Colors
        vc.titleLabel.textColor =  colorProvider.appTitleColor
        vc.descriptionLabel.textColor = colorProvider.appDefaultTextColor
        
        // MARK: - Fonts
        vc.titleLabel.font = AppFont.bold.withSize(32)
        vc.descriptionLabel.font = AppFont.regular.withSize(18)

        vc.imageView.image = imageProvider.warningPrivacyIcon
    }
    
    func applyDesign(to vc: MnemonicPhraseCopyViewController) {
        // MARK: - Localized Strings
        vc.copyButton.setTitle(LS("MnemonicPhrase.Copy"), for: .normal)
        vc.copyButton.setTitle(LS("MnemonicPhrase.Copied"), for: .selected)
        vc.continueButton.setTitle(LS("MnemonicPhrase.Continue"), for: .normal)
        vc.titleLabel.text = LS("MnemonicPhrase.Title")
        vc.descriptionLabel.text = LS("MnemonicPhrase.Description")

        // MARK: - Fonts
        vc.titleLabel.font = AppFont.bold.withSize(32)
        vc.descriptionLabel.font = AppFont.regular.withSize(18)
        
        // MARK: - State
        vc.copyButton.isSelected = false
        vc.continueButton.isEnabled = false
    }
}
