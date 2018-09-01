//
//  KeyStoreWarningViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class KeyStoreWarningViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: LS("WarningKeystore.Skip"),
                           title: "",
                           lAction: backAction,
                           rAction: skipAction),
            .title(title: LS("WarningKeystore.Title")),
            .empty(height: 8, background: colorProvider.settingsCellsBackround),
            .paragraph(title: LS("WarningKeystore.Paragraph1.Title"),
                       description: LS("WarningKeystore.Paragraph1.Description")),
            .empty(height: 8, background: colorProvider.settingsCellsBackround),
            .paragraph(title: LS("WarningKeystore.Paragraph2.Title"),
                       description: LS("WarningKeystore.Paragraph2.Description")),
            .empty(height: 8, background: colorProvider.settingsCellsBackround),
            .paragraph(title: LS("WarningKeystore.Paragraph3.Title"),
                       description: LS("WarningKeystore.Paragraph3.Description")),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("WarningKeystore.Save"),
                            isEnable: true,
                            action: saveAction),
            .empty(height: 10, background: colorProvider.settingsCellsBackround),
            .tabBarSpace
        ]
    }
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var skipAction: () -> Void = {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var saveAction: () -> Void = {
        (inject() as AuthRouterInterface).showNext()
    }
}
