//
//  TableComponentTableView.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI

class TableComponentTableView: UITableViewCell, NibLoadable {
    @IBOutlet weak var tableView: UITableView!
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    private var refreshAction: ((UIRefreshControl) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
    }
    
    public func enableRefresh(action: @escaping (UIRefreshControl) -> Void) {
        self.refreshAction = action
        self.tableView.refreshControl = UIRefreshControl()
        self.tableView.refreshControl?.addTarget(self, action: #selector(tableDidRefresh), for: .valueChanged)
    }
    
    @objc private func tableDidRefresh(refresh: UIRefreshControl) {
        refreshAction?(refresh)
    }
}
