//
//  ConfirmEthereumTransactionDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/13/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation

class ConfirmEthereumTransactionDetailViewController: BaseTableAdapterController {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        view.backgroundColor = .clear
        tableView.backgroundColor = .clear
    }
    
    private var state: [TableComponent] {
        return [.blure(state:
            [.centeredComponentTopInstet,
            .container(state: containerState)]
            )]
    }
    
    private var containerState: [TableComponent] {
        return []
//            [.titleWithFontAligment(font: AppFont.bold.withSize(17), title: <#T##String#>, aligment: <#T##NSTextAlignment#>, color: colorProvider.appTitleColor)]
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var  cancelAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
    }
    
    private lazy var confirmAction: () -> Void = { [weak self] in
        self?.dismiss(animated: true)
    }
}
