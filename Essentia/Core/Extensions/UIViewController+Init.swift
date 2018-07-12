//
//  UIViewController+Init.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

extension UIViewController {
    @nonobjc
    public override convenience init() {
        self.init(nibName: nil, bundle: nil)
    }
}
