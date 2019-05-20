//
//  WarningViewContrller.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssUI
import EssDI
import EssResources

class WarningViewContrller: BaseTableAdapterController, SwipeableNavigation {
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - State
    override var state: [TableComponent] {
        return [
            .empty(height: 30, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"), right: "", title: "", lAction: backAction, rAction: nil),
            .empty(height: 5, background: colorProvider.settingsCellsBackround),
            .title(bold: true, title: LS("Warning.Title")),
            .empty(height: 30, background: colorProvider.settingsCellsBackround),
            .centeredImageWithCalculatableSpace(image: imageProvider.warningPrivacyIcon),
            .empty(height: 30, background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("Warning.Done"), isEnable: true, action: doneAction, background: colorProvider.settingsCellsBackround),
            .empty(height: 20, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    // MARK: - Actions
    private lazy var doneAction: () -> Void = {
        (inject() as AuthRouterInterface).showNext()
    }
    
    private lazy var backAction: () -> Void = {
        (inject() as AuthRouterInterface).showPrev()
    }
}
