//
//  WalletWelcomeViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class WalletWelcomeViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 59, background: .clear),
            .title(bold: false, title: LS("Wallet.Welcome.Title1")),
            .title(bold: true, title: LS("Wallet.Welcome.Title2")),
            .empty(height: 16, background: .clear),
            .descriptionWithSize(fontSize: 17, title: LS("Settings.Secure.Description"), backgroud: .clear),
            .empty(height: 47, background: .clear),
            .imageParagraph(image: imageProvider.welcomeParagraph1, paragraph: LS("Wallet.Welcome.Paragraph1")),
            .empty(height: 16, background: .clear),
            .imageParagraph(image: imageProvider.welcomeParagraph2, paragraph: LS("Wallet.Welcome.Paragraph2")),
            .empty(height: 16, background: .clear),
            .imageParagraph(image: imageProvider.welcomeParagraph3, paragraph: LS("Wallet.Welcome.Paragraph3")),
            .calculatbleSpace(background: .clear),
            .centeredButton(title: LS("Wallet.Welcome.Continue"), isEnable: true, action: keystoreAction)
        ]
    }

    // MARK: - Actions
    private lazy var keystoreAction: () -> Void = {
        self.dismiss(animated: true)
    }
}
