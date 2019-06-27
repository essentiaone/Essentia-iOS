//
//  TableComponentTitleImageButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/16/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentTitleImageButton: UITableViewCell, NibLoadable {
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var action: (() -> Void)?
    
    @IBAction func cancelAction(_ sender: Any) {
        action?()
    }
}
