//
//  TableComponentSlider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableComponentSlider: UITableViewCell, NibLoadable {
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var centerTitleLabel: UILabel!
    
    let appColor: AppColorInterface = inject()
    var newSliderAction: ((Float) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    private func applyDesign() {
        [leftTitleLabel, rightTitleLabel, centerTitleLabel].forEach {
            $0?.font = AppFont.regular.withSize(11)
            $0?.textColor = appColor.appDefaultTextColor
        }
        slider.minimumTrackTintColor = appColor.appDefaultTextColor
        slider.maximumTrackTintColor = appColor.appDefaultTextColor
        slider.thumbTintColor = appColor.centeredButtonBackgroudColor
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        newSliderAction?(slider.value)
    }
}
