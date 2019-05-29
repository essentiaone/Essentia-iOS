//
//  WalletDoneImportingAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssUI
import EssResources

class WalletDoneImportingAlert: InfoAlertViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }

    private func applyTitles() {
        // MARK: - LocalizedStrings
        okButton.setTitle(LS("Wallet.DoneImporting.Button"), for: .normal)
        titleLabel.text = LS("Wallet.DoneImporting.Title")
        descriptionLabel.text = LS("Wallet.DoneImporting.Description")
        
        checkImageView.image = imageProvider.checkInfoIcon
    }
}
