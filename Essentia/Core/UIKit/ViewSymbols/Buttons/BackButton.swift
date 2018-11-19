//
//  BackButton.swift
//  Essentia
//
//  Created by Pavlo Boiko on 19.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BackButton: BaseButton {
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupTitle()
        setupIcon()
    }
    
    private func setupTitle() {
        setTitle( LS("Back"), for: .normal)
        titleLabel?.font = AppFont.regular.withSize(17)
    }
    
    private func setupIcon() {
        setImage(imageProvider.backButtonImage, for: .normal)
        imageView?.frame.size = CGSize(width: 13, height: 22)
        imageView?.contentMode = .scaleAspectFit
        
    }
}
