//
//  ReusableCell+Nib.swift
//  Essentia
//
//  Created by Pavlo Boiko on 21.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public protocol NibLoadable {
    static var nib: UINib { get }
}

public extension NibLoadable where Self: UICollectionViewCell & NibLoadable {
    public static var nib: UINib {
        return UINib(nibName: identifire, bundle: nil)
    }
}

public extension NibLoadable where Self: UITableViewCell & NibLoadable {
    public static var nib: UINib {
        return UINib(nibName: identifire, bundle: nil)
    }
}
