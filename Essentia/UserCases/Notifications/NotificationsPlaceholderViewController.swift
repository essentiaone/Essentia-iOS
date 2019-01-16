//
//  NotificationsPlaceholderViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

class NotificationsPlaceholderViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableAdapter.simpleReload(state)
    }
    
    private var state: [TableComponent] {
        return [
            .empty(height: 45, background: colorProvider.settingsCellsBackround),
            .titleWithFont(font: AppFont.bold.withSize(34),
                           title: LS("TabBar.Notifications"),
                           background: colorProvider.settingsCellsBackround,
                           aligment: .left),
            .empty(height: 70, background: colorProvider.settingsCellsBackround),
            .centeredImage(image: imageProvider.notificationPlaceholderIcon),
            .empty(height: 30, background: colorProvider.settingsCellsBackround),
            .descriptionWithSize(aligment: .center,
                                 fontSize: 17,
                                 title: LS("Notification.Placeholder.Description"),
                                 background: .white,
                                 textColor: colorProvider.appDefaultTextColor)
        ]
    }
}
