//
//  WalletMainViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

fileprivate struct Constans {
    static var currentSegment: Int = 0
}

class WalletMainViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var interator: WalletInteractorInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        injectRouter()
        injectInteractor()
        tableAdapter.reload(state)
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
        if EssentiaStore.currentUser.wallet.isEmpty {
            return emptyState
        }
        return [
        .tableWithHeight(height: 240, state: nonEmptyStaticState),
        .tableWithHeight(height: tableView.frame.height - 240, state: assetState)
        ]
    }
    
    var nonEmptyStaticState: [TableComponent] {
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .rightNavigationButton(title: LS("Wallet.Title"),
                                   image: imageProvider.bluePlus,
                                   action: addWalletAction),
            .empty(height: 20, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.regular.withSize(20),
                           title: LS("Wallet.Main.Balance.Title"),
                           background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.bold.withSize(32),
                           title: "$54,500,234.00",
                           background: colorProvider.settingsCellsBackround),
            .balanceChanging(status: .idle,
                             balanceChanged: "+3.5%",
                             perTime: "(24h)",
                             action: updateBalanceChanginPerDay),
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .segmentControlCell(titles: [LS("Wallet.Main.Segment.First"),
                                         LS("Wallet.Main.Segment.Segment")],
                                selected: Constans.currentSegment,
                                action: segmentControlAction)
        ]
    }
    
    var assetState: [TableComponent] {
        switch Constans.currentSegment {
        case 0:
            return coinsState
        case 1:
            return tokensState
        default: return []
        }
    }
    
    var emptyState: [TableComponent] {
        return [
            .empty(height: 24, background: colorProvider.settingsCellsBackround),
            .rightNavigationButton(title: "", image: imageProvider.bluePlus, action: addWalletAction),
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
    
    var tokensState: [TableComponent] {
        var tokenTabState: [TableComponent] = []
        let tokensByWallets = interator.getTokensByWalleets()
        for (key, value) in tokensByWallets {
            tokenTabState.append(contentsOf: buildSection(title: key.name, wallets: value))
        }
        return tokenTabState
    }
    
    var coinsState: [TableComponent] {
        var coinsTypesState: [TableComponent] = []
        coinsTypesState.append(contentsOf: buildSection(title: LS("Wallet.Main.Coins.Essntia"),
                                                        wallets: interator.getGeneratedWallets()))
        coinsTypesState.append(contentsOf: buildSection(title: LS("Wallet.Main.Coins.Imported"),
                                                        wallets: interator.getImportedWallets()))
        return coinsTypesState
    }
    
    func buildSection(title: String, wallets: [ViewWalletInterface]) -> [TableComponent] {
        guard !wallets.isEmpty else { return [] }
        var sectionState: [TableComponent] = []
        sectionState.append(.empty(height: 10, background: colorProvider.settingsBackgroud))
        sectionState.append(.descriptionWithSize(aligment: .left,
                                                 fontSize: 14,
                                                 title: title,
                                                 background: colorProvider.settingsBackgroud))
        sectionState.append(.empty(height: 10, background: colorProvider.settingsBackgroud))
        sectionState.append(contentsOf: buildStateForWallets(wallets))
        return sectionState
    }
    
    func buildStateForWallets(_ wallets: [ViewWalletInterface]) -> [TableComponent] {
        var assetState: [TableComponent] = []
        wallets.forEach { (wallet) in
            assetState.append(.assetBalance(image: wallet.icon,
                                            title: wallet.name,
                                            value: wallet.balanceInCurrentCurrency,
                                            currencyValue: wallet.balance,
                                            action: {
                                                
            }))
            assetState.append(.separator(inset: .zero))
        }
        return assetState
    }
    
    // MARK: - Actions
    private lazy var segmentControlAction: (Int) -> Void = {
        Constans.currentSegment = $0
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var addWalletAction: () -> Void = {
        (inject() as WalletRouterInterface).show(.newAssets)
    }
    
    private lazy var updateBalanceChanginPerDay: () -> Void = {
        
    }
}
