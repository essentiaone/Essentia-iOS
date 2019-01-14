//
//  BackupMnemonicAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore

class BackupMnemonicAlert: QuestionAlertViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    private func applyTitles() {
        imageView.image = (inject() as AppImageProviderInterface).mnemonicWaringIcon
        titleLabel.text = LS("MnemonicBackupWarning.Title")
        descriptionLabel.text = LS("MnemonicBackupWarning.Description")
        leftButton.setTitle(LS("MnemonicBackupWarning.LeftButton"), for: .normal)
        rightButton.setTitle(LS("MnemonicBackupWarning.RightButton"), for: .normal)
        leftButton.setTitleColor((inject() as AppColorInterface).appDefaultTextColor, for: .normal)
        rightButton.setTitleColor((inject() as AppColorInterface).centeredButtonBackgroudColor, for: .normal)
    }
}
