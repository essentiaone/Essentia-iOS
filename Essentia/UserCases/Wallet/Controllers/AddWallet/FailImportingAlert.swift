//
//  FailImportingAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore

class FailImportingAlert: QuestionAlertViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    private func applyTitles() {
        imageView.image = (inject() as AppImageProviderInterface).warningIcon
        titleLabel.text = LS("Wallet.FailImporing.Title")
        descriptionLabel.text = LS("Wallet.FailImporing.Description")
        leftButton.setTitle(LS("Wallet.FailImporing.LeftButton"), for: .normal)
        rightButton.setTitle(LS("Wallet.FailImporing.RightButton"), for: .normal)
        leftButton.setTitleColor((inject() as AppColorInterface).appDefaultTextColor, for: .normal)
        rightButton.setTitleColor((inject() as AppColorInterface).centeredButtonBackgroudColor, for: .normal)
    }
}
