//
//  BaseRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseRouter {
    weak var navigationController: UINavigationController?
    
    required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    func push(vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func popUp(vc: UIViewController) {
        vc.modalPresentationStyle = .custom
        navigationController?.topViewController?.present(vc, animated: true)
    }
    
    func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
