//
//  TableComponentCenteredButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentCenteredButton: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var rightInset: NSLayoutConstraint!
    @IBOutlet weak var leftInset: NSLayoutConstraint!
    @IBOutlet weak var titleButton: BaseButton!
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        titleButton.titleLabel?.font = AppFont.regular.withSize(15)
        titleButton.setTitleColor(colorProvider.centeredButtonTextColor, for: .normal)
        
        titleButton.drawCornerRadius()
        titleButton.drawShadow(width: 5)
    }
    
    func setEnable(_ isEnable: Bool) {
        let background = isEnable ? colorProvider.centeredButtonBackgroudColor :
                                   colorProvider.centeredButtonDisabledBackgroudColor
        titleButton.backgroundColor = background
        titleButton.isEnabled = isEnable
    }
    
    @IBAction func action(_ sender: Any) {
        action?()
    }
}
