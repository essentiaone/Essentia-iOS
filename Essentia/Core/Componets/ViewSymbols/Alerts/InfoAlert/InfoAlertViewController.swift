//
//  BlureAlertViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class InfoAlertViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var blureView: UIVisualEffectView!
    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let okAction: () -> Void
    
    // MARK: - Dependences
    lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Init
    init(okAction: @escaping () -> Void) {
        self.okAction = okAction
        super.init(nibName: "InfoAlertViewController", bundle: Bundle.main)
        self.modalPresentationStyle = .custom
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    // MARK: - Private
    private func applyDesign() {
        // MARK: - Colors
        titleLabel.textColor =  colorProvider.appTitleColor
        descriptionLabel.textColor = colorProvider.appDefaultTextColor
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
