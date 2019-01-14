//
//  TableComponentCenteredImage.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentCenteredImage: UITableViewCell, NibLoadable {
    @IBOutlet weak var verticalInset: NSLayoutConstraint!
    @IBOutlet weak var verticalInsetBottom: NSLayoutConstraint!
    @IBOutlet weak var titleImageView: UIImageView!
}
