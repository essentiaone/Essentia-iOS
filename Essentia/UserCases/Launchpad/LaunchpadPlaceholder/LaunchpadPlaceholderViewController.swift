//
//  LaunchpadPlaceholderViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/7/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class LaunchpadPlaceholderViewController: BaseViewController {
    @IBOutlet weak var topPlaceholderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var arrowLabel: UILabel!
    
    private var swipeRecognizer: UISwipeGestureRecognizer!
    private lazy var tableAdapter: TableAdapter = TableAdapter(tableView: tableView)
    
    override init() {
        super.init()
        swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.handleGesture(gesture:)))
        swipeRecognizer.direction = .up
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addRecognizer()
        applyDesign()
        self.tableAdapter.hardReload(state)
    }

    private func applyDesign() {
        titleLabel.text = LS("Launchpad.Placeholder.Title")
        arrowLabel.text = LS("Launchpad.Placeholder.Swipe")
        
        titleLabel.textColor = (inject() as AppColorInterface).appTitleColor
        arrowLabel.textColor = (inject() as AppColorInterface).centeredButtonBackgroudColor
        
        titleLabel.font = AppFont.bold.withSize(34)
        arrowLabel.font = AppFont.medium.withSize(16)
        
        titleImageView.image = UIImage(named: "launchpadPlaceholder")
        arrowImageView.image = UIImage(named: "upArrow")
    }
    
    private func addRecognizer() {
        topPlaceholderView.addGestureRecognizer(swipeRecognizer)
    }
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) {
        let heightAfterAnimation = -(self.view.frame.height + 20)
        animatePlaceholderTopConstraint(to: heightAfterAnimation)
        self.swipeRecognizer.isEnabled = false
    }
    
    private func animatePlaceholderTopConstraint(to value: CGFloat) {
        UIView.animate(withDuration: 0.5, animations: {
            self.placeholderViewTopConstraint.constant = value
            self.view.layoutIfNeeded()
        })
    }
    
    // MARK: - TableAdapter
    
    private var state: [TableComponent] {
        return [.empty(height: 48, background: RGB(183, 192, 208)),
        .centeredImageButton(image: UIImage(named: "upArrow")!, action: swipDownAction),
        .empty(height: 20, background: .white),
        .title(bold: true, title: LS("Launchpad.Placeholder.Detail.Title")),
        .empty(height: 20, background: .white)] + featuresState
    }
    
    private var featuresState: [TableComponent] {
        var features: [TableComponent] = []
        for i in 0..<11 {
            let componentName = "Launchpad.Placeholder.Detail.Feature\(i)."
            features.append(.imageTitleSubtitle(image: UIImage(named: "todo\(i)") ?? UIImage(),
                                                title: LS(componentName + "Title"),
                                                subtitle: LS(componentName + "Detail")))
            features.append(.separator(inset: UIEdgeInsets(top: 0, left: 114, bottom: 0, right: 0)))
        }
        return features
    }
    
    // MARK: - Actions
    
    private lazy var swipDownAction: () -> Void = {
        self.animatePlaceholderTopConstraint(to: -20)
        self.swipeRecognizer.isEnabled = true
    }
}
