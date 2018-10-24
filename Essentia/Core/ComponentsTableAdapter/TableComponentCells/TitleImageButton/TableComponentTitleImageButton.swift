//
//  TableComponentTitleImageButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/16/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentTitleImageButton: UITableViewCell, NibLoadable {
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var action: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        cancelButton.tintColor = colorProvider.appTitleColor
        cancelButton.setImage(imageProvider.cancelIcon, for: .normal)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        action?()
    }
}
