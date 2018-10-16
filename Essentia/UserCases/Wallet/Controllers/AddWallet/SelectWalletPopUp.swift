//
//  SelectWalletPopUp.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/16/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

final class SelectWalletPopUp: BaseTablePopUpController {
    private lazy var colorProvider: AppColorInterface = inject()
    
    init(wallets: [ViewWalletInterface], didSelect: @escaping (ViewWalletInterface) -> Void) {
        super.init(position: .bottom)
        var walletsState: [TableComponent] = []
        wallets.forEach { (wallet: ViewWalletInterface) in
            walletsState.append(.imageUrlTitle(imageUrl: wallet.iconUrl, title: wallet.name, withArrow: true, action: {
                didSelect(wallet)
                self.dismiss(animated: true)
            }))
            walletsState.append(.separator(inset: .init(top: 0, left: 60, bottom: 0, right: 0)))
        }
        let popUpState: [TableComponent] = [
            .empty(height: 17, background: colorProvider.settingsCellsBackround),
            .titleWithCancel(title: LS("Wallet.AddTokens.SelectRoot.Title"), action: cancelAction),
            .description(title: LS("Wallet.AddTokens.SelectRoot.Description"), backgroud: colorProvider.settingsCellsBackround),
                .empty(height: 8, background: colorProvider.settingsCellsBackround)
            ] + walletsState + [
            .empty(height: 15, background: colorProvider.settingsCellsBackround),
            ]
        state = popUpState
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var cancelAction: () -> Void = {
        self.dismiss(animated: true)
    }
}
