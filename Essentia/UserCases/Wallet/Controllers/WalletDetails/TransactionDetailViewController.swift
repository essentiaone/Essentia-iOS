//
//  TransactionDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/28/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssentiaBridgesApi

class TransactionDetailViewController: BaseTablePopUpController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    
    convenience init(transaction: EthereumTransactionDetail) {
        self.init()
        state = containerState
    }
    
    init() {
        super.init(position: .center)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var containerState: [TableComponent] {
        return [
        
        ]
    }
    
    private var exportAlert: [TableComponent] {
        return [.topAlert(alertType: .info, title: LS("Wallet.Options.Export.Copied"))]
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        applyDesign()
    }
    
    private func applyDesign() {
        self.view.backgroundColor = .clear
    }
    
    // MARK: - Actions
    
    private lazy var copyAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
//        UIPasteboard.general.string = self
        self.tableAdapter.simpleReload(self.state)
    }
    
}
