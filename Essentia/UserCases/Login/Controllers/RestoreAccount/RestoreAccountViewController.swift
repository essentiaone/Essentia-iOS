//
//  RestoreAccountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol RestoreAccountDelegate: class {
    func showBackup(type: BackupType)
}

class RestoreAccountViewController: BaseViewController {
    @IBOutlet weak var contenttableview: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var contentView: UIView!
    
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var tableAdapter = TableAdapter(tableView: contenttableview)
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private weak var delegate: RestoreAccountDelegate?
    
    init(delegate: RestoreAccountDelegate) {
        super.init()
        self.delegate = delegate
        modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    private var state: [TableComponent] {
        return [
            .imageTitle(image: imageProvider.mnemonicIcon,
                        title: LS("Restore.Mnemonic"),
                        withArrow: true,
                        action: mnemonicAction),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.seedIcon,
                        title: LS("Restore.Seed"),
                        withArrow: true,
                        action: seedAction),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.keystoreIcon,
                        title: LS("Restore.Keystore"),
                        withArrow: true,
                        action: keystoreAction)]
    }
    
    // MARK: - Lifecycly
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
        tableAdapter.reload(state)
    }
    
    private func applyDesign() {
        contentView.layer.cornerRadius = 10.0
        titleLabel.text = LS("Restore.Title")
        detailLabel.text = LS("Restore.Description")
        
        titleLabel.font = AppFont.bold.withSize(21)
        detailLabel.font = AppFont.regular.withSize(15)
        
        titleLabel.textColor = colorProvider.titleColor
        detailLabel.textColor = colorProvider.appDefaultTextColor
        cancelButton.setImage(imageProvider.cancelIcon, for: .normal)
    }
    
    // MARK: - Actions
    @IBAction func cancelAction(_ sender: AnyObject) {
        dismiss(animated: true)
    }
    
    private lazy var keystoreAction: () -> Void = {
        self.delegate?.showBackup(type: .keystore)
    }
    
    private lazy var seedAction: () -> Void = {
        self.delegate?.showBackup(type: .seed)
    }
    
    private lazy var mnemonicAction: () -> Void = {
        self.delegate?.showBackup(type: .mnemonic)
    }
}
