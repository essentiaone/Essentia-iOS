//
//  TableComponentTitleDetail.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentTitleDetail: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    func applyDesign() {
        textLabel?.font = AppFont.regular.withSize(14)
        detailTextLabel?.font = AppFont.regular.withSize(14)

        textLabel?.textColor = colorProvider.settingsMenuTitle
        detailTextLabel?.textColor = colorProvider.settingsMenuSubtitle
    }
}
