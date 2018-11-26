//
//  BaseTableAdapterController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseTableAdapterController: BaseViewController {
    // MARK: - Init
    let tableView: UITableView
    lazy var tableAdapter = TableAdapter(tableView: tableView)
    private var scrollObserver: NSKeyValueObservation?
    private var topView: UIView?
    private var bottomView: UIView?
    
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
        setupScrollInsets()
    }
    
    private func setupScrollInsets() {
        tableView.backgroundColor = .clear
        let oneViewHeight = tableView.frame.height / 2
        topView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: oneViewHeight))
        bottomView = UIView(frame: CGRect(x: 0, y: oneViewHeight, width: tableView.frame.width, height: oneViewHeight))
        view.insertSubview(topView!, belowSubview: tableView)
        view.insertSubview(bottomView!, belowSubview: tableView)
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        view.addSubview(tableView)
        [NSLayoutConstraint.Attribute.top, .bottom, .leading, .trailing].forEach {
            view.addConstraint(NSLayoutConstraint(item: tableView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0))
        }
    }
    
    func addLastCellBackgroundContents(topColor: UIColor, bottomColor: UIColor) {
        let oneViewHeight = tableView.frame.height / 2
        topView?.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: oneViewHeight)
        bottomView?.frame = CGRect(x: 0, y: oneViewHeight, width: tableView.frame.width, height: oneViewHeight)
        topView?.backgroundColor = topColor
        bottomView?.backgroundColor = bottomColor
        scrollObserver = tableView.observe(\.contentOffset, options: .new) { (_, change) in
            guard let yChange = change.newValue?.y else { return }
            let overTopScroll = yChange <= -oneViewHeight
            let overBottomScroll = yChange + self.tableView.frame.height > self.tableView.contentSize.height + oneViewHeight
            UIView.animate(withDuration: 0.5, animations: {
                self.tableView.isScrollEnabled = !overTopScroll && !overBottomScroll
            })
        }
    }

}
