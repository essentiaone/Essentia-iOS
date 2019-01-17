//
//  BlureAlertViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

open class InfoAlertViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet public weak var blureView: UIVisualEffectView!
    @IBOutlet public weak var alertContentView: UIView!
    @IBOutlet public weak var okButton: UIButton!
    @IBOutlet public weak var checkImageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    
    let okAction: () -> Void
    
    // MARK: - Dependences
    public lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Init
    public init(okAction: @escaping () -> Void) {
        self.okAction = okAction
        super.init(nibName: "InfoAlertViewController", bundle: currentBundle)
        self.modalPresentationStyle = .custom
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override open func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    // MARK: - Private
    private func applyDesign() {
        // MARK: - Colors
        titleLabel.textColor =  colorProvider.appTitleColor
        descriptionLabel.textColor = colorProvider.appTitleColor
        okButton.setTitleColor(colorProvider.centeredButtonBackgroudColor, for: .normal)
        
        // MARK: - Fonts
        titleLabel.font = AppFont.bold.withSize(17)
        descriptionLabel.font = AppFont.regular.withSize(15)
        
        // MARK: - Layout
        alertContentView.layer.cornerRadius = 10
        alertContentView.layer.opacity = 0.95
    }
    
    // MARK: - Actions
    @IBAction func okAction(_ sender: Any) {
        dismiss(animated: true)
        okAction()
    }
}
