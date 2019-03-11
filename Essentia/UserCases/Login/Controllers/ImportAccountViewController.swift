//
//  ImportAccountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 2/25/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssCore
import EssResources
import EssUI
import EssDI

protocol ImportAccountDelegate: class {
    func importAccountWith(sourceType: BackupSourceType, backupType: BackupType) 
}

class ImportAccountViewController: BaseBluredTableAdapterController {
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private weak var delegate: ImportAccountDelegate?
    
    // MARK: - Init
    init(delegate: ImportAccountDelegate) {
        super.init()
        self.delegate = delegate
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    private var state: [TableComponent] {
        return [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 25, background: .clear)]
    }

    private var containerState: [TableComponent] {
        return [
            .empty(height: 10, background: .white),
            .titleWithCancel(title: LS("Settings.ImportAccount.Title"), action: cancelAction),
            .description(title: LS("Settings.ImportAccount.Description"), backgroud: .clear),
            .imageTitle(image: imageProvider.importApp,
                        title: LS("Settings.ImportAccount.EssentiaApp"),
                        withArrow: true,
                        action: importFromApp),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.importWeb,
                        title: LS("Settings.ImportAccount.EssentiaWeb"),
                        withArrow: true,
                        action: importFromWeb),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.importOthers,
                        title: LS("Settings.ImportAccount.Others"),
                        withArrow: true,
                        action: importFromOtherWallet)]
    }
    // MARK: - Lifecycly
    override func viewDidLoad() {
        super.viewDidLoad()
        tableAdapter.hardReload(state)
    }
    
    private func selectBackupType(sourceType: BackupSourceType) {
        self.present(SelectBackupTypeViewConroller(title: sourceType.title, selectBackupType: { (backupType) in
            self.delegate?.importAccountWith(sourceType: sourceType, backupType: backupType)
        }), animated: true)
    }
    
    // MARK: - Actions
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var importFromApp: () -> Void = { [unowned self] in
        self.selectBackupType(sourceType: .app)
    }
    
    private lazy var importFromWeb: () -> Void = { [unowned self] in
        self.selectBackupType(sourceType: .web)
    }
    
    private lazy var importFromOtherWallet: () -> Void = { [unowned self] in
        self.present(ImportFromOtherController(selectBackupSourceType: { (type) in
            self.selectBackupType(sourceType: type)
        }), animated: true)
    }
}
