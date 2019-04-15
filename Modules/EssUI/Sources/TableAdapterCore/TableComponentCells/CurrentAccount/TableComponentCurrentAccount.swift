//
//  TableComponentCurrentAccount.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssModel
import EssResources

class TableComponentCurrentAccount: UITableViewCell, NibLoadable {
    @IBOutlet weak var accountAvatarView: AvatarHashView!
    @IBOutlet weak var accountTitleLabel: UILabel!
    @IBOutlet weak var accountDescription: UILabel!
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        accountTitleLabel.text = LS("Settings.CurrentAccountTitle")
        
        accountTitleLabel.font = AppFont.regular.withSize(14)
        accountDescription.font = AppFont.medium.withSize(18)
        
        accountTitleLabel.textColor = colorProvider.settingsMenuSubtitle
        accountDescription.textColor = colorProvider.titleColor
        
        accountAvatarView.layer.cornerRadius = accountAvatarView.layer.bounds.width / 2
        accountAvatarView.clipsToBounds = true
    }
}
