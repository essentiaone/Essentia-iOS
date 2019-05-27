//
//  SelectPurchaseWalletViewController.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 5/27/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

final class SelectPurchaseWalletViewController: BaseBluredTableAdapterController {
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
    
    override var state: [TableComponent] {
        return [.centeredComponentTopInstet,
                .container(state: containerState)]
    }
    
    private var containerState: [TableComponent] {
        return
            [
                .empty(height: 5, background: colorProvider.settingsCellsBackround),
                .titleWithCancel(title: LS("PaidAccount.SelectWallet.Title"), action: cancelAction),
                .empty(height: 8, background: colorProvider.settingsCellsBackround)
                ] + walletsState + [
                .empty(height: 5, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    private var walletsState: [TableComponent] {
        return wallets |> buildWalletState |> concat
    }
    
    private func buildWalletState(_ wallet: ViewWalletInterface) -> [TableComponent] {
        return  [.imageUrlTitle(imageUrl: wallet.iconUrl, title: wallet.name, withArrow: true, action: { [unowned self] in
            self.didSelect(wallet)
            self.dismiss(animated: true)
        }),
                 .separator(inset: .init(top: 0, left: 60, bottom: 0, right: 0))]
    }
    
    // MARK: - Actions
    
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
}
