//
//  SelectPurchaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 5/21/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssUI
import EssDI

class SelectPurchaseViewController: BaseTableAdapterController, SwipeableNavigation {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    override var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: LS("PaidAccount.SelectPurchase.Restore"),
                           title: "",
                           lAction: backAction,
                           rAction: restoreAction),
            .empty(height: 19, background: .clear),
            .title(bold: true, title: LS("PaidAccount.SelectPurchase.Title")),
            .calculatbleSpace(background: .clear),
            .centeredImage(image: imageProvider.keystoreIcon),
            .empty(height: 19, background: .clear),
            .description(title: "PaidAccount.SelectPurchase.Info", backgroud: .clear),
            .empty(height: 25, background: .clear)
        ]
    }
    
    private lazy var restoreAction: () -> Void = { [unowned self] in
        
    }
    
    private lazy var backAction: () -> Void = { [unowned self] in
        
    }
}
