//
//  StatableControllerInterface.swift
//  EssUI
//
//  Created by Pavlo Boiko on 5/26/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit

public protocol StatableControllerInterface {
    var state: [TableComponent] { get }
    var tableView: UITableView { get }
    var tableAdapter: TableAdapter { get set }
}

extension StatableControllerInterface where Self: UIViewController {
    public func showInfo(_ message: String, type: AlertType, atIndex: Int = 1) {
        var updateState = state
        updateState.insert(.alert(alertType: type, title: message), at: atIndex)
        tableAdapter.performTableUpdate(newState: updateState, withAnimation: .toTop)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            guard let self = self else { return }
            self.tableAdapter.performTableUpdate(newState: self.state, withAnimation: .toTop)
        }
    }
}
