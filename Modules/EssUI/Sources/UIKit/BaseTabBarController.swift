//
//  BaseTabBarController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 09.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

open class BaseTabBarController: UITabBarController {
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
