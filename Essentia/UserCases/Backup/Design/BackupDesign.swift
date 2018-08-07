//
//  BackupDesign.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

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
        
        // MARK: - Colors
        vc.titleLabel.textColor =  colorProvider.appTitleColor
        vc.descriptionLabel.textColor = colorProvider.appDefaultTextColor
        
        // MARK: - State
        vc.copyButton.isSelected = false
        vc.continueButton.isEnabled = false
    }
    
    func applyDesign(to vc: MnemonicPhraseConfirmViewController) {
        // MARK: - Localized Strings
        vc.titleLabel.text = LS("MnemonicPhraseConfirm.Title")
        vc.descriptionLabel.text = LS("MnemonicPhraseConfirm.Description")
        
        // MARK: - Fonts
        vc.titleLabel.font = AppFont.bold.withSize(32)
        vc.descriptionLabel.font = AppFont.regular.withSize(18)
        vc.currentWordLabel.font = AppFont.regular.withSize(15)
        
        // MARK: - Colors
        vc.titleLabel.textColor =  colorProvider.appTitleColor
        vc.descriptionLabel.textColor = colorProvider.appDefaultTextColor

        // MARK: - Layout
        vc.confirmWordsCollectionView.layer.cornerRadius = 3
        vc.confirmWordsCollectionView.layer.borderColor = colorProvider.blueBorderColor.cgColor
        vc.confirmWordsCollectionView.layer.borderWidth = 1.0
    }

    func applyDesign(to vc: SeedCopyViewController) {
        // MARK: - Localized Strings
        vc.copyButton.setTitle(LS("SeedCopy.Copy"), for: .normal)
        vc.copyButton.setTitle(LS("SeedCopy.Copied"), for: .selected)
        vc.continueButton.setTitle(LS("SeedCopy.Continue"), for: .normal)
        vc.titleLabel.text = LS("SeedCopy.Title")
        vc.descriptionLabel.text = LS("SeedCopy.Description")
        vc.textView.text = vc.seed
        
        // MARK: - Fonts
        vc.titleLabel.font = AppFont.bold.withSize(32)
        vc.descriptionLabel.font = AppFont.regular.withSize(18)
        vc.textView.font = AppFont.regular.withSize(16)
        
        // MARK: - Colors
        vc.titleLabel.textColor =  colorProvider.appTitleColor
        vc.descriptionLabel.textColor = colorProvider.appDefaultTextColor
        vc.textView.textColor = colorProvider.appTitleColor
        
        // MARK: - State
        vc.copyButton.isSelected = false
        vc.continueButton.isEnabled = false
        
        // MARK: - Layout
        vc.textView.layer.cornerRadius = 3
        vc.textView.layer.borderColor = colorProvider.blueBorderColor.cgColor
        vc.textView.layer.borderWidth = 1.0
    }
    
    func applyDesign(to vc: KeyStorePasswordViewController) {
        // MARK: - Localized Strings
        vc.continueButton.setTitle(LS("SeedCopy.Continue"), for: .normal)
        vc.titleLabel.text = LS("SeedCopy.Title")
        vc.descriptionLabel.text = LS("SeedCopy.Description")
        
        // MARK: - Fonts
        vc.titleLabel.font = AppFont.bold.withSize(32)
        vc.descriptionLabel.font = AppFont.regular.withSize(18)
        vc.passwordTextField.font = AppFont.regular.withSize(16)
        
        // MARK: - Colors
        vc.titleLabel.textColor =  colorProvider.appTitleColor
        vc.descriptionLabel.textColor = colorProvider.appDefaultTextColor
        vc.passwordTextField.textColor = colorProvider.appTitleColor
    }
}
