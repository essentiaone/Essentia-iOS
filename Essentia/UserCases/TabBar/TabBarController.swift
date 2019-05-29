//
//  TabBarController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 09.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssUI
import EssDI

fileprivate enum Constants: String {
    case walletOnbordingKey
}

fileprivate enum TabBarTab {
    case launchpad
    case wallet
    case notifications
    case settings
    
    private var title: String {
        switch self {
        case .launchpad:
            return LS("TabBar.Launchpad")
        case .wallet:
            return LS("TabBar.Wallet")
        case .notifications:
            return LS("TabBar.Notifications")
        case .settings:
            return LS("TabBar.Settings")
        }
    }
    
    private var icon: UIImage {
        let imageProvider: AppImageProviderInterface = inject()
        switch self {
        case .launchpad:
            return imageProvider.launchpadIcon
        case .wallet:
            return imageProvider.walletIcon
        case .notifications:
            return imageProvider.notificationsIcon
        case .settings:
            return imageProvider.settingsIcon
        }
    }
    
    private var controller: UIViewController {
        switch self {
        case .launchpad:
            return UIViewController()
        case .wallet:
            return WalletMainViewController()
        case .notifications:
            return NotificationsPlaceholderViewController()
        case .settings:
            return SettingsViewController()
        }
    }
    
    var tabBarItem: BaseNavigationController {
        let navigationController = BaseNavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: title, image: icon, selectedImage: nil)
        navigationController.setNavigationBarHidden(true, animated: false)
        navigationController.hidesBottomBarWhenPushed = true
        return navigationController
    }
}

class TabBarController: BaseTabBarController, UITabBarControllerDelegate {
    static var shared: TabBarController = TabBarController()
    // MARK: - Init
    override init() {
        super.init()
        delegate = self
        let items: [TabBarTab] = [.wallet, .notifications, .settings]
        viewControllers = items.map {
            let nvc = $0.tabBarItem
            loadDependences(tabBarTab: $0, nvc: nvc)
            return nvc
        }
        tabBar.layer.borderWidth = 0.0
        tabBar.backgroundImage = UIImage.withColor(.white)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectTab(at index: Int) {
        tabBar.selectedItem = tabBar.items?[index]
    }
    
    private func loadDependences(tabBarTab: TabBarTab, nvc: BaseNavigationController) {
        switch tabBarTab {
        case .settings:
            prepareInjection(SettingsRouter(navigationController: nvc) as SettingsRouterInterface, memoryPolicy: .viewController)
        case .wallet:
            prepareInjection(WalletInteractor() as WalletInteractorInterface, memoryPolicy: .viewController)
            prepareInjection(WalletBlockchainWrapperInteractor() as WalletBlockchainWrapperInteractorInterface, memoryPolicy: .viewController)
            prepareInjection(WalletRouter(tabBarController: self, nvc: nvc) as WalletRouterInterface, memoryPolicy: .viewController)
        default: return
        }
    }
}
