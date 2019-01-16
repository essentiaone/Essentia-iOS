//
//  TableComponentTableView.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentTableView: UITableViewCell, NibLoadable {
    @IBOutlet weak var tableView: UITableView!
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
    }
}
