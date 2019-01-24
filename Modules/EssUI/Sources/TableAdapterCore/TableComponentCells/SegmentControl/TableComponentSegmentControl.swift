//
//  TableComponentSegmentControl.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssDI
import EssResources

fileprivate enum SegmentType {
    case filled
    case selectable
}

class TableComponentSegmentControl: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    private var segmentType: SegmentType = .selectable
    
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var segmentControllerChangedAtIndex: ((Int) -> Void)?
    
    func applySelectableDesign() {
        segmentControl.layer.cornerRadius = 3.0
        segmentControl.clipsToBounds = true
        segmentControl.backgroundColor = colorProvider.settingsCellsBackround
        segmentControl.tintColor = colorProvider.centeredButtonBackgroudColor
    }
    
    func applyOneColorDesign() {
        segmentControl.layer.cornerRadius = 21.0
        segmentControl.clipsToBounds = true
        [UIControl.State.selected, .normal].forEach { (state) in
            segmentControl.setTitleTextAttributes(
                [NSMutableAttributedString.Key.foregroundColor: colorProvider.centeredButtonTextColor],
                for: state)
        }
        segmentControl.setDividerImage(UIImage.withColor( colorProvider.centeredButtonTextColor),
                                       forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
        segmentControl.backgroundColor = colorProvider.centeredButtonBackgroudColor
        segmentControl.tintColor = colorProvider.centeredButtonBackgroudColor
        segmentType = .filled
    }
    
    func setTitles(_ titles: [String]) {
        segmentControl.removeAllSegments()
        titles.enumerated().forEach { (offset, title) in
            segmentControl.insertSegment(withTitle: title, at: offset, animated: false)
        }
    }
    
    @IBAction func segmentControllChanged(_ sender: UISegmentedControl) {
        self.segmentControllerChangedAtIndex?(sender.selectedSegmentIndex)
        if segmentType == .filled {
            sender.selectedSegmentIndex = -1
        }
    }
}
