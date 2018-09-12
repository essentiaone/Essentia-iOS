//
//  KeystoreSavedAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class KeystoreSavedAlert: InfoAlertViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }
    
    private func applyTitles() {
        // MARK: - LocalizedStrings
        okButton.setTitle(LS("InfoAlert.Ok"), for: .normal)
        titleLabel.text = LS("KeyStoreSaved.Title")
        descriptionLabel.text = LS("KeyStoreSaved.Description")
        
        checkImageView.image = imageProvider.checkInfoIcon
    }
}
