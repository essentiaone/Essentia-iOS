//
//  TableComponentDescription.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentDescription: UITableViewCell {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
         self.textLabel?.textColor = colorProvider.settingsMenuSubtitle
        self.textLabel?.font = AppFont.regular.withSize(14)
    }
}
