//
//  LoginDesign.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

class LoginDesign: LoginDesignInterface {
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    func applyDesign(to vc: WelcomeViewController) {
        // MARK: - Localized Strings
        vc.restoreButton.setTitle(LS("Welcome.Restore"), for: .normal)
        vc.title1Label.text = LS("Welcome.Title1")
        vc.title2Label.text = LS("Welcome.Title2")
        vc.descriptionLabel.text = LS("Welcome.Description")
        if (inject() as UserStorageServiceInterface).get().isEmpty {
            vc.enterButton.setTitle(LS("Welcome.Start"), for: .normal)
        } else {
            vc.enterButton.setTitle(LS("Welcome.Enter"), for: .normal)
        }
        
        let termsAttributedText = NSMutableAttributedString()
        termsAttributedText.append(
            NSAttributedString(
                string: LS("Welcome.Tersm1"),
                attributes: [.font: AppFont.regular.withSize(13)]
            )
        )
        termsAttributedText.append(
            NSAttributedString(
                string: LS("Welcome.Tersm2"),
                attributes: [.font: AppFont.regular.withSize(13),
                             .underlineStyle: NSUnderlineStyle.single.rawValue]
            )
        )
        vc.termsButton.setAttributedTitle(termsAttributedText, for: .normal)
        
        // MARK: - Colors
        vc.title1Label.textColor = colorProvider.appTitleColor
        vc.title2Label.textColor = colorProvider.appTitleColor
        vc.descriptionLabel.textColor = colorProvider.appDefaultTextColor
        vc.termsButton.titleLabel?.textColor = colorProvider.appLinkTextColor
        
        // MARK: - Font
        
        vc.title1Label.font = AppFont.regular.withSize(36)
        vc.title2Label.font = AppFont.bold.withSize(36)
        vc.descriptionLabel.font = AppFont.regular.withSize(18)
    }
}
