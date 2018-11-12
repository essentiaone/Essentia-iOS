//
//  TableComponentBlure.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/10/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentBlure: UITableViewCell, NibLoadable {
    @IBOutlet weak var blureView: UIVisualEffectView!
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
        tableView.backgroundColor = .clear
        backgroundColor = .clear
    }
}
