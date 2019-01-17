//
//  BaseNavigationController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/17/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

open class BaseNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    private var canSwipe: Bool = false
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return canSwipe
    }
    
    override open func pushViewController(_ viewController: UIViewController, animated: Bool) {
        super.pushViewController(viewController, animated: animated)
        checkNavigation(viewController: viewController)
    }
    
    override open func popViewController(animated: Bool) -> UIViewController? {
        checkNavigation(viewController: viewControllers.last)
        return super .popViewController(animated: animated)
    }
    
    override open func popToRootViewController(animated: Bool) -> [UIViewController]? {
        canSwipe = false
        return super.popToRootViewController(animated: animated)
    }
    
    override open func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        checkNavigation(viewController: viewControllers.last)
    }
    
    private func checkNavigation(viewController: UIViewController?) {
        guard viewController is SwipeableNavigation else {
            canSwipe = false
            return
        }
        canSwipe = true
    }
}
