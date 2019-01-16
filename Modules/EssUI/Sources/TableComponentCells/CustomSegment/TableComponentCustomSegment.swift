//
//  TableComponentCustomSegment.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/14/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore

class TableComponentCustomSegment: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var indicatorView: UIView!
    
    var action: ((Int) -> Void)?
    var selectedIndex: Int = 0
    var indicatorHeight: CGFloat = 2
    
    override func layoutSubviews() {
        super.layoutSubviews()
        applyDesign()
        layoutIndicator()
    }
    
    private func applyDesign() {
        indicatorView.backgroundColor = colorProvider.centeredButtonBackgroudColor
        segmentControl.subviews.forEach {
            $0.tintColor = colorProvider.appDefaultTextColor
        }
        segmentControl.setTitleTextAttributes([NSMutableAttributedString.Key.foregroundColor: colorProvider.centeredButtonBackgroudColor], for: .selected)
        segmentControl.setBackgroundImage(UIImage(), for: .normal, barMetrics: .default)
        segmentControl.setDividerImage(UIImage(), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    
    private func layoutIndicator() {
        self.indicatorView.layoutIfNeeded()
        UIView.animate(withDuration: 0.3) {
            let indicatorWidth = self.frame.width / CGFloat(self.segmentControl.numberOfSegments)
            self.indicatorView.frame = CGRect(x: CGFloat(self.selectedIndex) * indicatorWidth, y: self.frame.height - self.indicatorHeight, width: indicatorWidth, height: self.indicatorHeight)
            self.layoutIfNeeded()
        }
    }
    
    @IBAction func didSelectSegment(_ sender: UISegmentedControl) {
        selectedIndex = sender.selectedSegmentIndex
        action?(selectedIndex)
        layoutIndicator()
    }
}
