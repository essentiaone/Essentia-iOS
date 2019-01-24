//
//  QuestionAlertViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 29.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

open class QuestionAlertViewController: UIViewController {
    // MARK: - IBOutlet
    @IBOutlet public weak var blureView: UIVisualEffectView!
    @IBOutlet public weak var alertContentView: UIView!
    @IBOutlet public weak var leftButton: UIButton!
    @IBOutlet public weak var rightButton: UIButton!
    @IBOutlet public weak var imageView: UIImageView!
    @IBOutlet public weak var titleLabel: UILabel!
    @IBOutlet public weak var descriptionLabel: UILabel!
    
    // MARK: - Dependences
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    private var leftAction: () -> Void
    private var rightAction: () -> Void
    
    public init(leftAction: @escaping () -> Void, rightAction: @escaping () -> Void) {
        self.leftAction = leftAction
        self.rightAction = rightAction
        super.init(nibName: "QuestionAlertViewController", bundle: currentBundle)
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
        titleLabel.textColor = colorProvider.appTitleColor
        descriptionLabel.textColor = colorProvider.appTitleColor
        
        // MARK: - Fonts
        titleLabel.font = AppFont.bold.withSize(17)
        descriptionLabel.font = AppFont.regular.withSize(15)
        
        // MARK: - Layout
        alertContentView.layer.cornerRadius = 10
        alertContentView.layer.opacity = 0.95
    }
    
    @IBAction func leftAction(_ sender: Any) {
        dismiss(animated: true)
        leftAction()
    }
    
    @IBAction func rightAction(_ sender: Any) {
        dismiss(animated: true)
        rightAction()
    }
}
