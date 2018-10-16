//
//  TableComponentSegmentControl.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentSegmentControl: UITableViewCell, NibLoadable {
    private lazy var colorProvider: AppColorInterface = inject()
    
    @IBOutlet var segmentControl: UISegmentedControl!
    
    var segmentControllerChangedAtIndex: ((Int) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        segmentControl.layer.cornerRadius = 3.0
        segmentControl.clipsToBounds = true
        segmentControl.backgroundColor = colorProvider.settingsCellsBackround
        segmentControl.tintColor = colorProvider.centeredButtonBackgroudColor
    }
    
    func setTitles(_ titles: [String]) {
        segmentControl.removeAllSegments()
        titles.enumerated().forEach { (offset, title) in
            segmentControl.insertSegment(withTitle: title, at: offset, animated: false)
        }
    }
    
    @IBAction func segmentControllChanged(_ sender: UISegmentedControl) {
        self.segmentControllerChangedAtIndex?(sender.selectedSegmentIndex)
    }
}
