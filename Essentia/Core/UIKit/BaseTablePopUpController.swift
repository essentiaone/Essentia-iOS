//
//  BaseTablePopUpController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/16/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum BasePopUpPosition {
    case center
    case bottom
    
    var horizontalInset: CGFloat {
        switch self {
        case .bottom:
            return 15.0
        case .center:
            return 25.0
        }
    }
    
    var verticalInset: CGFloat {
        return 20
    }
}

class BaseTablePopUpController: BaseBluredController {
    private var tableView: UITableView
    private let position: BasePopUpPosition
    var state: [TableComponent] = []
    
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    
    init(position: BasePopUpPosition) {
        self.position = position
        self.tableView = UITableView()
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutIfNeeded()
        tableAdapter.hardReload(state)
        applyDesign()
    }
    
    private func applyDesign() {
        blureView.contentView.addSubview(tableView)
        tableView.layer.cornerRadius = 14.0
        applyConstranints()
    }
    
    private func applyConstranints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        blureView.contentView.addConstraint(NSLayoutConstraint(item: blureView.contentView, attribute: .trailing, relatedBy: .equal, toItem: tableView, attribute: .trailing, multiplier: 1, constant: position.horizontalInset))
        blureView.contentView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .leading, relatedBy: .equal, toItem: blureView.contentView, attribute: .leading, multiplier: 1, constant: position.horizontalInset))
        switch position {
        case .bottom:
            blureView.contentView.addConstraint(NSLayoutConstraint(item: blureView.contentView, attribute: .bottom, relatedBy: .equal, toItem: tableView, attribute: .bottom, multiplier: 1, constant: position.verticalInset))
        case .center:
            blureView.contentView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .centerY, relatedBy: .equal, toItem: blureView.contentView, attribute: .centerY, multiplier: 1, constant: 0))
        }
        let contentHeight = tableAdapter.helper.allContentHeight(for: state)
        print(contentHeight)
        let maxContentHeight = blureView.frame.height - position.verticalInset
        let height = contentHeight <= maxContentHeight ? contentHeight : maxContentHeight
        blureView.contentView.addConstraint(NSLayoutConstraint(item: tableView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: height))
    }
}
