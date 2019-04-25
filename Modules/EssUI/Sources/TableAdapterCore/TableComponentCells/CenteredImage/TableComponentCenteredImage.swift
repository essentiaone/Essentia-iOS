//
//  TableComponentCenteredImage.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI

class TableComponentCenteredImage: UITableViewCell, NibLoadable {
    @IBOutlet weak var verticalInset: NSLayoutConstraint!
    @IBOutlet weak var verticalInsetBottom: NSLayoutConstraint!
    @IBOutlet weak var titleImageView: UIImageView!
    var imageAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imageViewAction))
        titleImageView.addGestureRecognizer(gesture)
        titleImageView.isUserInteractionEnabled = true
    }
    
    @objc func imageViewAction() {
        imageAction?()
    }
}
