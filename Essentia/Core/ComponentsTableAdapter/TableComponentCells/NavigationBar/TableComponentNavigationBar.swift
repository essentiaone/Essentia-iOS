//
//  TableComponentNavigationBar.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentNavigationBar: UITableViewCell, NibLoadable {
    // MARK: - Dependences
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var leftAction: (() -> Void)?
    var rightAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        leftButton.isHidden = leftAction != nil
        rightButton.isHidden = rightAction != nil
        titleLabel.font = AppFont.bold.withSize(16)
        
        leftButton.imageView?.contentMode = .scaleAspectFit
        leftButton.titleLabel?.font = AppFont.regular.withSize(15.0)
        rightButton.titleLabel?.font = AppFont.regular.withSize(15.0)
    }
    
    @IBAction func leftButtonAction(_ sender: Any) {
        self.leftAction?()
    }
    
    @IBAction func rightButtonAction(_ sender: Any) {
        self.rightAction?()
    }
}
