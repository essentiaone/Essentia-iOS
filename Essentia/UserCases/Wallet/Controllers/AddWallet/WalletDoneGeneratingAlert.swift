//
//  WalletDoneGeneratingAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/22/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class WalletDoneGeneratingAlert: InfoAlertViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    private func applyTitles() {
        // MARK: - LocalizedStrings
        okButton.setTitle(LS("Wallet.DoneGenerating.Button"), for: .normal)
        titleLabel.text = LS("Wallet.DoneGenerating.Title")
        descriptionLabel.text = LS("Wallet.DoneGenerating.Description")
        
        checkImageView.image = imageProvider.checkInfoIcon
    }
}
