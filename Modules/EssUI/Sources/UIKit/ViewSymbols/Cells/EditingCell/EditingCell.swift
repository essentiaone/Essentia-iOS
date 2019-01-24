//
//  EditingCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 31.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

open class EditingCell: BaseCollectionViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    public func setTitle(string: String, placeholder: String) {
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(NSAttributedString(string: string,
                                                          attributes:
            [
                NSAttributedString.Key.foregroundColor: colorProvider.currentWordEnteringString,
                NSAttributedString.Key.font: AppFont.medium.withSize(15)]))
        mutableAttributedString.append(NSAttributedString(string: placeholder,
                                                          attributes:
            [
                NSAttributedString.Key.foregroundColor: colorProvider.currentWordEnteringPlaceholder,
                NSAttributedString.Key.font: AppFont.medium.withSize(15)]))
        titleLabel.attributedText = mutableAttributedString
    }
}
