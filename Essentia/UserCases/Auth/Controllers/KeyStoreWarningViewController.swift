//
//  KeyStoreWarningViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssUI
import EssDI

class KeyStoreWarningViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    
    override var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .title(bold: true, title: LS("WarningKeystore.Title")),
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
                            action: saveAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: 10, background: colorProvider.settingsCellsBackround)
        ]
    }
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = { [unowned self] in
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var skipAction: () -> Void = { [unowned self] in
        (inject() as AuthRouterInterface).showPrev()
    }
    
    private lazy var saveAction: () -> Void = { [unowned self] in
        (inject() as AuthRouterInterface).showNext()
    }
}
