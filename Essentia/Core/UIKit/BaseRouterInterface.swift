//
//  BaseRouterInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol BaseRouterInterface {
    init(navigationController: UINavigationController)
    func pop()
}
