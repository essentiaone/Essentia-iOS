//
//  TableComponentSwitch.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentSwitch: UITableViewCell, NibLoadable {
    @IBOutlet weak var switchView: UISwitch!
    var action: ((Bool) -> Void)?
    
    private lazy var colorProvider: AppColorInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        textLabel?.font = AppFont.regular.withSize(14)
        textLabel?.textColor = colorProvider.settingsMenuTitle
    }
    
    @IBAction func switchChanged(_ sender: UISwitch) {
        DispatchQueue.main.async { [weak self] in
            self?.action?(sender.isOn)
        }
    }
}
