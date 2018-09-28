//
//  BaseTableAdapterController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseTableAdapterController: BaseViewController {
    // MARK: - Init
    let tableView: UITableView
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    
    public override init() {
        tableView = UITableView()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        [NSLayoutConstraint.Attribute.top, .bottom, .leading, .trailing].forEach {
            view.addConstraint(NSLayoutConstraint(item: tableView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0))
        }
    }
    
    override func keyboardDidChange() {
        super.keyboardDidChange()
    }

}
