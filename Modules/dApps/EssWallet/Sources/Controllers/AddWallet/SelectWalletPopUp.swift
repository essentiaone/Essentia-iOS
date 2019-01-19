//
//  SelectWalletPopUp.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/16/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI

final class SelectWalletPopUp: BaseBluredTableAdapterController {
    private lazy var colorProvider: AppColorInterface = inject()
    private var wallets: [ViewWalletInterface]
    private var didSelect: (ViewWalletInterface) -> Void
    
    init(wallets: [ViewWalletInterface], didSelect: @escaping (ViewWalletInterface) -> Void) {
        self.wallets = wallets
        self.didSelect = didSelect
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State

    private var state: [TableComponent] {
        return [.centeredComponentTopInstet,
                .container(state: containerState)]
    }
    
    private var containerState: [TableComponent] {
         return [
            .empty(height: 5, background: colorProvider.settingsCellsBackround),
            .titleWithCancel(title: LS("Wallet.AddTokens.SelectRoot.Title"), action: cancelAction),
            .description(title: LS("Wallet.AddTokens.SelectRoot.Description"), backgroud: colorProvider.settingsCellsBackround),
            .empty(height: 8, background: colorProvider.settingsCellsBackround)
            ] + walletsState + [
            .empty(height: 5, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    private var walletsState: [TableComponent] {
        return wallets.map({ wallet -> [TableComponent] in
            return [.imageUrlTitle(imageUrl: wallet.iconUrl, title: wallet.name, withArrow: true, action: { [unowned self] in
                        self.didSelect(wallet)
                        self.dismiss(animated: true)
                    }),
                    .separator(inset: .init(top: 0, left: 60, bottom: 0, right: 0))]
        }).flatMap { return $0 }
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableAdapter.hardReload(state)
    }
    
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
}
