//
//  TableComponentMenuButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentMenuButton: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.font = AppFont.regular.withSize(14)
    }
}
