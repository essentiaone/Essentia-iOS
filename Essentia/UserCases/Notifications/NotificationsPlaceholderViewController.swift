//
//  NotificationsPlaceholderViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class NotificationsPlaceholderViewController: BaseViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeholderImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    private func applyDesign() {
        placeholderImageView.image = (inject() as AppImageProviderInterface).notificationPlaceholderIcon
        titleLabel.text = LS("TabBar.Notifications")
        titleLabel.font = AppFont.bold.withSize(34)
    }
}
