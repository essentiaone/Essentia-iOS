//
//  TableAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    // MARK: - State
    private var tableState: [TableComponent] = []
    private var tableView: UITableView
    
    // MARK: - Init
    public init(tableView: UITableView) {
        self.tableView = tableView
        super.init()
    }
    
    private func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        registerCells()
    }
    
    func registerCells() {
        self.tableView.register(TableComponentEmpty.self)
        self.tableView.register(TableComponentSeparator.self)
        self.tableView.register(TableComponentTitle.self)
    }
    
    // MARK: - Update State
    func updateState(_ state: [TableComponent]) {
        self.tableState = state
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableState.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let component = tableState[indexPath.row]
        switch component {
        case .empty(_, let background):
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = background
            return cell
        case .separator:
            return (tableView.dequeueReusableCell(for: indexPath) as TableComponentSeparator)
        case .title(let title):
            let cell: TableComponentTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.title.text = title
            return cell
        case .accountStrengthAction(let progress, let action):
            let cell: TableComponentAccountStrengthAction = tableView.dequeueReusableCell(for: indexPath)
            cell.resultAction = action
            cell.progress = progress
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let component = tableState[indexPath.row]
        switch component {
        case .separator:
            return 1.0
        case .empty(let height, _):
            return height
        case .title(let title):
            return title.multyLineLabelHeight(with: AppFont.bold.withSize(36), width: tableView.frame.width)
        case .accountStrengthAction:
            return 394.0
        default:
            fatalError()
        }
    }
}
