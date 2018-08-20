//
//  TableAdapterHelper.swift
//  Essentia
//
//  Created by Pavlo Boiko on 16.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableAdapterHelper {
    let tableView: UITableView
    init(tableView: UITableView) {
        self.tableView = tableView
    }
    
    func heightForEmptySpace(with state: [TableComponent], in adapter: TableAdapter) -> CGFloat {
        var totalContentHeight: CGFloat = 0
        for (index, item) in state.enumerated() {
            switch item {
            case .calculatbleSpace:
                break
            default:
                totalContentHeight += adapter.tableView(tableView, heightForRowAt: IndexPath(row: index, section: 0))
                break
            }
        }
        let resultHeight = tableView.frame.height - totalContentHeight
        return resultHeight > 0.0 ? resultHeight : 0.0
    }
    
}
