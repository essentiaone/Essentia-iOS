//
//  TableComponentCheckField.swift
//  Essentia
//
//  Created by Pavlo Boiko on 24.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentCheckField: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        textLabel?.font = AppFont.regular.withSize(17)
        textLabel?.textColor = colorProvider.settingsMenuTitle
    }
}
