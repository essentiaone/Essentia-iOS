//
//  TableComponentShadow.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentShadow: UITableViewCell, NibLoadable {
    @IBOutlet weak var shadowView: UIView!
    
     func drawGradient(withColor: UIColor) {
        shadowView.layer.shadowRadius = frame.height
        shadowView.layer.shadowColor = withColor.cgColor
        shadowView.layer.shadowOpacity = 1
        shadowView.clipsToBounds = false
    }
}
