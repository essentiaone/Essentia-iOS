//
//  LaunchpadPlaceholderViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/7/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources
import EssUI

class LaunchpadPlaceholderViewController: BaseViewController {
    @IBOutlet weak var topPlaceholderView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var placeholderViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var arrowLabel: UILabel!
    
    private var swipeRecognizer: UISwipeGestureRecognizer!
    private var scrollObserver: NSKeyValueObservation?
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.insertSubview(topView!, at: 0)
        view.insertSubview(bottomView!, at: 0)
        addLastCellBackgroundContents(topColor: RGB(183, 192, 208), bottomColor: .white)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        view.removeGestureRecognizer(swipeRecognizer)
    }
    
    private func applyDesign() {
        titleLabel.text = LS("Launchpad.Placeholder.Title")
        arrowLabel.text = LS("Launchpad.Placeholder.Swipe")
        
        titleLabel.textColor = (inject() as AppColorInterface).appTitleColor
        arrowLabel.textColor = (inject() as AppColorInterface).centeredButtonBackgroudColor
        tableView.backgroundColor = .clear
        
        titleLabel.font = AppFont.bold.withSize(34)
        arrowLabel.font = AppFont.medium.withSize(16)
        
        titleImageView.image = (inject() as AppImageProviderInterface).launchpadPlaceholder
        arrowImageView.image = (inject() as AppImageProviderInterface).upArrow
    }
    
    private func addRecognizer() {
        topPlaceholderView.addGestureRecognizer(swipeRecognizer)
        scrollObserver = tableView.observe(\.contentOffset, options: .new) { [unowned self] (_, change) in
            guard let newValue = change.newValue,
                newValue.y < -80,
                !self.swipeRecognizer.isEnabled else { return }
            self.swipDownAction()
        }
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
        .centeredImageButton(image:  (inject() as AppImageProviderInterface).downArrow, action: swipDownAction),
        .empty(height: 20, background: .white),
        .titleWithFont(font: AppFont.bold.withSize(34), title: LS("Launchpad.Placeholder.Detail.Title"), background: .white, aligment: .left),
        .empty(height: 20, background: .white)] + featuresState
    }
    
    private var featuresState: [TableComponent] {
        var features: [TableComponent] = []
        for i in 0..<11 {
            let componentName = "Launchpad.Placeholder.Detail.Feature\(i)."
            let image = AppImageProvider.image(name: "todo\(i)")
            features.append(.imageTitleSubtitle(image: image,
                                                title: LS(componentName + "Title"),
                                                subtitle: LS(componentName + "Detail")))
            features.append(.separator(inset: UIEdgeInsets(top: 0, left: 114, bottom: 0, right: 0)))
        }
        return features
    }
    
    // MARK: - Actions
    
    private lazy var swipDownAction: () -> Void = { [unowned self] in
        self.animatePlaceholderTopConstraint(to: -20)
        self.swipeRecognizer.isEnabled = true
    }
}
