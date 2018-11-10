//
//  TableComponentSlider.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var separatorsCount = 6
}

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
        slider.minimumTrackTintColor = appColor.separatorBackgroundColor
        slider.maximumTrackTintColor = appColor.separatorBackgroundColor
        slider.thumbTintColor = appColor.centeredButtonBackgroudColor
        let separatorsCount = Constants.separatorsCount
        for i in 0..<separatorsCount {
            slider.addSubview(tickView(at: i))
        }
    }
    
    @IBAction func sliderAction(_ sender: Any) {
        newSliderAction?(slider.value)
    }
    
    func tickView(at index: Int) -> UIView {
        let offset: CGFloat = (CGFloat(frame.size.width - 30.0) / CGFloat(Constants.separatorsCount - 1)) * CGFloat(index)
        let view = UIView(frame: CGRect(x: offset + 1, y: 11, width: 2, height: 10))
        view.backgroundColor = appColor.separatorBackgroundColor
        return view
    }
}
