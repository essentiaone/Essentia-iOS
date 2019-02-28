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
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private weak var delegate: ImportAccountDelegate?
    
    // MARK: - Int
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
            .empty(height: 18, background: .clear)]
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
                        title: "MetaMast",
                        withArrow: true,
                        action: importFromMetaMask),
            .separator(inset: UIEdgeInsets(top: 0, left: 45, bottom: 0, right: 0)),
            .imageTitle(image: imageProvider.testAvatar,
                        title: "Exodus",
                        withArrow: true,
                        action: importFromExodus)]
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
    
    private lazy var importFromJaxx: () -> Void = { [unowned self] in
        self.delegate?.importOthers(type: .jaxx)
    }
    
    private lazy var importFromMetaMask: () -> Void = { [unowned self] in
        self.delegate?.importOthers(type: .metaMask)
    }
    
    private lazy var importFromExodus: () -> Void = { [unowned self] in
        self.delegate?.importOthers(type: .exodus)
    }
}
