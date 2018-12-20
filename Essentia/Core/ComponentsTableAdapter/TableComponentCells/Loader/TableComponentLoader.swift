//
//  TableComponentLoader.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12/20/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentLoader: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        showLoader()
    }
    
    func showLoader() {
        let indicator = UIActivityIndicatorView(frame: frame)
        indicator.style = .white
        addSubview(indicator)
        indicator.startAnimating()
    }
}
