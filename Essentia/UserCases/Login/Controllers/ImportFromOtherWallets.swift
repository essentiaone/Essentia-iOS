//
//  ImportFromOtherWallets.swift
//  Essentia
//
//  Created by Pavlo Boiko on 2/27/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssCore
import EssResources
import EssUI
import EssDI

class ImportFromOtherController: BaseBluredTableAdapterController {
    // MARK: - Dependences
    private lazy var userService: UserStorageServiceInterface = inject()
    private var selectBackupSourceType: (BackupSourceType) -> Void
    
    // MARK: - Int
    init(selectBackupSourceType: @escaping (BackupSourceType) -> Void) {
        self.selectBackupSourceType = selectBackupSourceType
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - State
    override var state: [TableComponent] {
        return [
            .calculatbleSpace(background: .clear),
            .container(state: containerState),
            .empty(height: 25, background: .clear)]
    }
    
    private var containerState: [TableComponent] {
        return [
            .empty(height: 10, background: .white),
            .titleWithCancel(title: LS("Settings.ImportOther.Title"), action: cancelAction),
            .imageTitle(image: imageProvider.testAvatar,
                        title: "Jaxx",
                        withArrow: true,
                        action: importFromJaxx),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.testAvatar,
                        title: "MetaMask",
                        withArrow: true,
                        action: importFromMetaMask),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.testAvatar,
                        title: "Exodus",
                        withArrow: true,
                        action: importFromExodus)]
    }
    
    // MARK: - Actions
    private lazy var cancelAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true)
    }
    
    private lazy var importFromJaxx: () -> Void = { [unowned self] in
        self.dismiss(animated: true, completion: {
            self.selectBackupSourceType(.jaxx)
        })
    }
    
    private lazy var importFromMetaMask: () -> Void = { [unowned self] in
        self.dismiss(animated: true, completion: {
            self.selectBackupSourceType(.metaMask)
        })
    }
    
    private lazy var importFromExodus: () -> Void = { [unowned self] in
        self.dismiss(animated: true, completion: {
            self.selectBackupSourceType(.exodus)
        })
    }
}
