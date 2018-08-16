//
//  TableComponentDescription.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentDescription: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        self.titleLabel?.textColor = colorProvider.settingsMenuSubtitle
        self.titleLabel?.font = AppFont.regular.withSize(14)
    }
}
