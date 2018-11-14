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
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    private func applyDesign() {
        placeholderImageView.image = (inject() as AppImageProviderInterface).notificationPlaceholderIcon
        titleLabel.text = LS("TabBar.Notifications")
        titleLabel.font = AppFont.bold.withSize(34)
        descriptionLabel.text = LS("Notification.Placeholder.Description")
        descriptionLabel.font = AppFont.regular.withSize(17)
        descriptionLabel.textColor = (inject() as AppColorInterface).appDefaultTextColor
    }
}
