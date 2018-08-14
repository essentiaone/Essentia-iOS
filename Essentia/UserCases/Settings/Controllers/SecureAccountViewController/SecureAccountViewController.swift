//
//  SecureAccountViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 14.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class SecureAccountViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    private lazy var tableAdapter = TableAdapter(tableView: tableView)
    
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applyDesign()
        tableAdapter.updateState(state)
    }
    
    // MARK: - Override
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Design
    private func applyDesign() {
        tableView.backgroundColor = colorProvider.settingsCellsBackround
    }
    
    private var state: [TableComponent] {
        return [
            .accountStrength(progress: 10, backAction: backAction)
        ]
    }
    
    // MARK: - Actions
    
    private lazy var backAction: () -> Void = {
        
    }
}
