//
//  TableComponentBorderedButton.swift
//  EssUI
//
//  Created by Bohdan Sinchuk on 24.04.19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentBorderedButton: UITableViewCell, NibLoadable {
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
        titleButton.setTitleColor(colorProvider.borderedButtonTextColor, for: .normal)
        
        titleButton.drawCornerRadius()
    }
    
    func drawBorder( color: CGColor, width: CGFloat) {
        titleButton.layer.borderColor = color
        titleButton.layer.borderWidth = width
    }
    
    @IBAction func action(_ sender: Any) {
        self.action?()
    }
}
