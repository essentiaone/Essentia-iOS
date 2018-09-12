//
//  WalletMainViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

class WalletMainViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
        injectRouter()
        injectInteractor()
    }
    
    private func injectInteractor() {
        let injection: WalletInteractorInterface = WalletInteractor()
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private func injectRouter() {
        guard let navigation = navigationController else { return }
        let injection: WalletRouterInterface = WalletRouter(navigationController: navigation)
        prepareInjection(injection, memoryPolicy: .viewController)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .rightNavigationButton(image: imageProvider.bluePlus, action: addWalletAction),
            .title(bold: true, title: LS("Wallet.Title")),
            .empty(height: 52, background: colorProvider.settingsCellsBackround),
            .centeredImage(image: imageProvider.walletPlaceholder),
            .empty(height: 40, background: colorProvider.settingsCellsBackround),
            .descriptionWithSize(aligment: .center,
                                 fontSize: 17,
                                 title: LS("Wallet.Empty.Description"),
                                 background: colorProvider.settingsCellsBackround),
            .empty(height: 10, background: colorProvider.settingsCellsBackround),
            .smallCenteredButton(title: LS("Wallet.Empty.Add"), isEnable: true, action: addWalletAction)
        ]
    }
    
    // MARK: - Actions
    private lazy var addWalletAction: () -> Void = {
        (inject() as WalletRouterInterface).show(.newAssets)
    }
}
