//
//  WarningViewContrller.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class WarningViewContrller: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var doneButton: CenteredButton!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Dependences
    private lazy var design: BackupDesignInterface = inject()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        design.applyDesign(to: self)
    }
    
    // MARK: - Actions
    @IBAction func doneAction(_ sender: Any) {
        (inject() as BackupRouterInterface).showNext()
    }
    
    @IBAction func backAction(_ sender: Any) {
        (inject() as BackupRouterInterface).showPrev()
    }
}
