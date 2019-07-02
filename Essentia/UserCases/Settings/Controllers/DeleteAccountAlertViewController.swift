//
//  DeleteAccountAlertViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 6/28/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssResources
import EssUI
import EssDI

class DeleteAccountAlertViewController: QuestionAlertViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    private func applyTitles() {
        imageView.image = (inject() as AppImageProviderInterface).warningIcon
        titleLabel.text = LS("DeleteAccountAlert.Title")
        descriptionLabel.text = LS("DeleteAccountAlert.Description")
        leftButton.setTitle(LS("DeleteAccountAlert.LeftButton"), for: .normal)
        rightButton.setTitle(LS("DeleteAccountAlert.RightButton"), for: .normal)
        leftButton.setTitleColor((inject() as AppColorInterface).centeredButtonBackgroudColor, for: .normal)
        rightButton.setTitleColor((inject() as AppColorInterface).appDefaultTextColor, for: .normal)
    }
}
