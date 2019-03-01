//
//  ImportFromAppViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssCore
import EssResources
import EssUI
import EssDI

class SelectBackupTypeViewConroller: BaseBluredTableAdapterController {
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private var selectBackupType: (BackupType) -> Void
    private var importTitle: String
    
    public init(title: String, selectBackupType: @escaping (BackupType) -> Void) {
        self.importTitle = title
        self.selectBackupType = selectBackupType
        super.init()
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
            .titleWithCancel(title: importTitle, action: cancelAction),
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
        tableAdapter.hardReload(state)
    }
    
    // MARK: - Actions
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var keystoreAction: () -> Void = { [unowned self] in
        self.selectBackupType(.keystore)
    }
    
    private lazy var seedAction: () -> Void = { [unowned self] in
        self.selectBackupType(.seed)
    }
    
    private lazy var mnemonicAction: () -> Void = { [unowned self] in
        self.selectBackupType(.mnemonic)
    }
}
