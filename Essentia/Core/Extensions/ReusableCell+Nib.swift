//
//  ReusableCell+Nib.swift
//  Essentia
//
//  Created by Pavlo Boiko on 21.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol NibLoadable {
    static var nib: UINib { get }
}

extension NibLoadable where Self: UICollectionViewCell & NibLoadable {
    static var nib: UINib {
        return UINib(nibName: identifire, bundle: nil)
    }
}

extension NibLoadable where Self: UITableViewCell & NibLoadable {
    static var nib: UINib {
        return UINib(nibName: identifire, bundle: nil)
    }
}
