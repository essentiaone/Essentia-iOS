//
//  BaseTwoTabsTableAdapterController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/1/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseTwoTabsTableAdapterController: BaseViewController {
    private var topTableView: UITableView
    private var buttomTableView: UITableView
    
    init(topTableHeight: CGFloat) {
        topTableView = UITableView()
        buttomTableView = UITableView()
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
        topTableView.translatesAutoresizingMaskIntoConstraints = false
        buttomTableView.translatesAutoresizingMaskIntoConstraints = false
        topTableView.alwaysBounceVertical = false
        buttomTableView.alwaysBounceVertical = false
        topTableView.separatorStyle = .none
        buttomTableView.separatorStyle = .none
        view.addSubview(topTableView)
        view.addSubview(topTableView)
        [NSLayoutConstraint.Attribute.top, .bottom, .leading, .trailing].forEach {
            view.addConstraint(NSLayoutConstraint(item: topTableView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0))
        }
        
        [NSLayoutConstraint.Attribute.top, .bottom, .leading, .trailing].forEach {
            view.addConstraint(NSLayoutConstraint(item: topTableView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0))
        }
    }
    
    override func keyboardDidChange() {
        super.keyboardDidChange()
    }
}
