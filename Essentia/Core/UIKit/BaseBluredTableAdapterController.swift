//
//  BaseBluredTableAdapterController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/27/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

//Duplicated Base table adapter controller
class BaseBluredTableAdapterController: BaseBluredController {
    let tableView: UITableView
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    private var scrollObserver: NSKeyValueObservation?
    
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
        
        blureView.contentView.addSubview(tableView)
        [NSLayoutConstraint.Attribute.top, .bottom, .leading, .trailing].forEach {
            blureView.contentView.addConstraint(NSLayoutConstraint(item: tableView, attribute: $0, relatedBy: .equal, toItem: blureView.contentView, attribute: $0, multiplier: 1, constant: 0))
        }
    }
}
