//
//  MnemonicPhraseCopyViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class MnemonicPhraseCopyViewController: BaseViewController, SwipeableNavigation {
    // MARK: - IBOutlet
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var continueButton: CenteredButton!
    
    // MARK: - Dependence
    private lazy var design: BackupDesignInterface = inject()
    private lazy var collectionViewAdapter = CenteringCollectionViewAdapter(components: mnemonic, in: collectionView)
    
    // MARK: - Store
    private let mnemonic: String
    
    // MARK: - Init
    required init(mnemonic: String) {
        self.mnemonic = mnemonic
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
        collectionViewAdapter.loadCollection()
    }
    
    // MARK: - Actions
    @IBAction func backAction(_ sender: Any) {
        (inject() as AuthRouterInterface).showPrev()
    }
    
    @IBAction func copyAction(_ sender: Any) {
        copyButton.isSelected = true
        continueButton.isEnabled = true
        UIPasteboard.general.string = mnemonic
        TopAlert(alertType: .info, title: "Mnemonic Phrase сopied", inView: self.view).show()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        EssentiaStore.shared.currentUser.backup.currentlyBackedUp.insert(.mnemonic)
        (inject() as UserStorageServiceInterface).storeCurrentUser()
        (inject() as AuthRouterInterface).showNext()
    }
    
}
