//
//  SeedCopyViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 06.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SeedCopyViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var continueButton: CenteredButton!
    @IBOutlet weak var separatorView: UIView!
    
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    
    // MARK: - Store
    let seed: String
    
    // MARK: - Init
    required init(seed: String) {
        self.seed = seed
        super.init()
    }
    
    required override init() {
        fatalError("init() has not been implemented")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        design.applyDesign(to: self)
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as BackupRouterInterface).showPrev()
    }
    
    @IBAction func copyAction(_ sender: Any) {
        copyButton.isSelected = true
        continueButton.isEnabled = true
        UIPasteboard.general.string = seed
    }
    
    @IBAction func continueAction(_ sender: Any) {
        EssentiaStore.currentUser.currentlyBackedUp.append(.seed)
        (inject() as BackupRouterInterface).showNext()
    }
}
