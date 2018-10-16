//
//  TableComponentTitleSubtitle.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentTitleSubtitle: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        textLabel?.font = AppFont.regular.withSize(16)
        detailTextLabel?.font = AppFont.regular.withSize(14)
        
        textLabel?.textColor = colorProvider.settingsMenuTitle
        detailTextLabel?.textColor = colorProvider.settingsMenuSubtitle
    }
}
