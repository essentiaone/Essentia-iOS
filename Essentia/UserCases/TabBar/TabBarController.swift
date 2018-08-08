//
//  TabBarController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 09.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TabBarController: BaseTabBarController, UITabBarControllerDelegate {
    // MARK: - Init
    override init() {
        super.init()
        delegate = self
        viewControllers = [launchpad, wallet, notifications, settings]
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - TabBarItems
    private var launchpad: UIViewController {
        let vc = LaunchpadViewController()
        vc.tabBarItem = UITabBarItem(title: LS("TabBar.Launchpad"), image: nil, selectedImage: nil)
        return vc
    }
    
    private var wallet: UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: LS("TabBar.Wallet"), image: nil, selectedImage: nil)
        return vc
    }
    
    private var notifications: UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: LS("TabBar.Notifications"), image: nil, selectedImage: nil)
        return vc
    }
    
    private var settings: UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: LS("TabBar.Settings"), image: nil, selectedImage: nil)
        return vc
    }
}
