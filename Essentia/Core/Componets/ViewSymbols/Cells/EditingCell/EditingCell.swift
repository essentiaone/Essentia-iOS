//
//  EditingCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 31.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class EditingCell: BaseCollectionViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    func setTitle(string: String, placeholder: String) {
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(NSAttributedString(string: string,
                                                          attributes:
            [
                NSAttributedStringKey.foregroundColor: colorProvider.currentWordEnteringString,
                NSAttributedStringKey.font: AppFont.medium.withSize(15)]))
        mutableAttributedString.append(NSAttributedString(string: placeholder,
                                                          attributes:
            [
                NSAttributedStringKey.foregroundColor: colorProvider.currentWordEnteringPlaceholder,
                NSAttributedStringKey.font: AppFont.medium.withSize(15)]))
        titleLabel.attributedText = mutableAttributedString
    }
}
