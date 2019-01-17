//
//  TableComponentLoader.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/20/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentLoader: UITableViewCell {
    override func layoutSubviews() {
        let indicator = UIActivityIndicatorView(frame: bounds)
        indicator.style = .gray
        addSubview(indicator)
        indicator.startAnimating()
    }
}
