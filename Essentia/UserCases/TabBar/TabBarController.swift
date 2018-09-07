//
//  TabBarController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 09.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

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
            return LaunchpadViewController()
        case .wallet:
            return UIViewController()
        case .notifications:
            return NotificationsPlaceholderViewController()
        case .settings:
            return SettingsViewController()
        }
    }
    
    var tabBarItem: UIViewController {
        let navigationController = UINavigationController(rootViewController: controller)
        navigationController.tabBarItem = UITabBarItem(title: title, image: icon, selectedImage: nil)
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}

class TabBarController: BaseTabBarController, UITabBarControllerDelegate {
    // MARK: - Init
    override init() {
        super.init()
        delegate = self
        let items: [TabBarTab] = [.launchpad, .wallet, .notifications, .settings]
        viewControllers = items.map { return $0.tabBarItem }
        hidesBottomBarWhenPushed = false
        tabBar.layer.borderWidth = 0.0
        tabBar.clipsToBounds = true
        tabBar.backgroundImage = UIImage.withColor(.white)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let isWalletTab = item.title == LS("TabBar.Wallet")
        let isFirstlyOnWallet = EssentiaStore.currentUser.userEvents.isFirstlyOnWallet
        if isWalletTab && isFirstlyOnWallet {
            EssentiaStore.currentUser.userEvents.isFirstlyOnWallet = false
            present(WalletWelcomeViewController(), animated: true)
        }
    }
}
