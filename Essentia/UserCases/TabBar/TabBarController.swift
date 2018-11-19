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
            return LaunchpadPlaceholderViewController()
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
    // MARK: - Init
    override init() {
        super.init()
        delegate = self
        let items: [TabBarTab] = [.launchpad, .wallet, .notifications, .settings]
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
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        let isWalletTab = item.title == LS("TabBar.Wallet")
        let isFirstlyOnWallet = EssentiaStore.shared.currentUser.userEvents.isFirstlyOnWallet
        if isWalletTab && isFirstlyOnWallet {
            EssentiaStore.shared.currentUser.userEvents.isFirstlyOnWallet = false
            (inject() as UserStorageServiceInterface).storeCurrentUser()
            present(WalletWelcomeViewController(), animated: true)
        }
    }
    
    private func loadDependences(tabBarTab: TabBarTab, nvc: BaseNavigationController) {
        switch tabBarTab {
        case .settings:
            prepareInjection(SettingsRouter(navigationController: nvc) as SettingsRouterInterface, memoryPolicy: .viewController)
        case .wallet:
            prepareInjection(WalletInteractor() as WalletInteractorInterface, memoryPolicy: .viewController)
            prepareInjection(WalletBlockchainWrapperInteractor() as WalletBlockchainWrapperInteractorInterface, memoryPolicy: .viewController)
            prepareInjection(WalletRouter(navigationController: nvc) as WalletRouterInterface, memoryPolicy: .viewController)
        default: return
        }
    }
}
