//
//  TableComponentContainer.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/10/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentContainer: UITableViewCell, NibLoadable {
    @IBOutlet weak var containerContentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        containerContentView.layer.cornerRadius = 14
        containerContentView.clipsToBounds = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
    }
}
