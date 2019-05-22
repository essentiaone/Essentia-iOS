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
    override var state: [TableComponent] {
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: LS("PaidAccount.SelectPurchase.Restore"),
                           title: "",
                           lAction: backAction,
                           rAction: restoreAction),
            .empty(height: 10, background: .clear),
            .title(bold: true, title: LS("PaidAccount.SelectPurchase.Title")),
            .calculatbleSpace(background: .clear),
            .centeredImage(image: imageProvider.selectPurchaseTypeIcon),
            .empty(height: 19, background: .clear),
            .descriptionWithSize(aligment: .left,
                                 fontSize: 17,
                                 title: LS("PaidAccount.SelectPurchase.Info"),
                                 background: .clear,
                                 textColor: colorProvider.appLinkTextColor),
            .empty(height: 25, background: .clear),
            .buttonWithSubtitle(title: LS("PaidAccount.SelectPurchase.PayForOne"), subtitle: "FOR 5 ESS", color: colorProvider.centeredButtonBackgroudColor, action: buyOneAccount),
            .empty(height: 10, background: .clear),
            .buttonWithSubtitle(title: LS("PaidAccount.SelectPurchase.PayForUnlimited"), subtitle: "FOR 100 ESS", color: colorProvider.copyButtonBackgroundSelectedColor, action: buyUnlimitedAccounts),
            .empty(height: 16, background: .clear)
        ]
    }
    
    private lazy var buyOneAccount: () -> Void = { [unowned self] in
        
    }
    
    private lazy var buyUnlimitedAccounts: () -> Void = { [unowned self] in
        
    }
    
    private lazy var restoreAction: () -> Void = { [unowned self] in
        
    }
    
    private lazy var backAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
}
