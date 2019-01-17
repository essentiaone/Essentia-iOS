//
//  LaunchpadItemCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 09.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

fileprivate struct Constants {
    static var imageCornerRadius: CGFloat = 14.0
}

open class LaunchpadItemCell: BaseCollectionViewCell, NibLoadable {
    // MARK: - IBOutlet
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var subtitleLabel: UILabel!
    
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()

    // MARK: - Lifecycle
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupDesign()
    }
    
    private func setupDesign() {
        // MARK: - Layer
        imageView.layer.cornerRadius = Constants.imageCornerRadius
        
        // MARK: - Font
        titleLabel.font = AppFont.medium.withSize(15.0)
        subtitleLabel.font = AppFont.regular.withSize(12.0)
        
        // MARK: - Color
        titleLabel.textColor = colorProvider.launchpadItemTitleColor
        subtitleLabel.textColor = colorProvider.launchpadItemSubTitleColor
    }
    
}
