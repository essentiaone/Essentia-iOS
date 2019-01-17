//
//  BaseRouter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

open class BaseRouter {
    public weak var navigationController: UINavigationController?
    
    public required init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    public func pop() {
        navigationController?.popViewController(animated: true)
    }
    
    public func push(vc: UIViewController) {
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    public func popUp(vc: UIViewController) {
        vc.modalPresentationStyle = .custom
        navigationController?.topViewController?.present(vc, animated: true)
    }
    
    public func popToRoot() {
        navigationController?.popToRootViewController(animated: true)
    }
}
