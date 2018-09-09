//
//  BlureAlertViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 08.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class InfoAlertViewController: BaseViewController {
    // MARK: - IBOutlet
    @IBOutlet weak var blureView: UIVisualEffectView!
    @IBOutlet weak var alertContentView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var checkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    let alertTitle: String
    let alertDescription: String
    let okAction: () -> Void
    // MARK: - Show
    static func show(from: UIViewController? = nil, title: String, description: String, okAction: (() -> Void)? = nil) {
        let root = from ?? UIApplication.shared.keyWindow?.rootViewController
        let alert = InfoAlertViewController(title: title, description: description) {
            root?.dismiss(animated: true)
            okAction?()
        }
        alert.modalPresentationStyle = .custom
        root?.present(alert, animated: true)
    }
    
    // MARK: - Dependences
    private lazy var imageProvider: AppImageProviderInterface = inject()
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Init
    init(title: String, description: String, okAction: @escaping () -> Void) {
        self.alertTitle = title
        self.alertDescription = description
        self.okAction = okAction
        super.init()
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
        // MARK: - LocalizedStrings
        okButton.setTitle(LS("InfoAlert.Ok"), for: .normal)
        titleLabel.text = alertTitle
        descriptionLabel.text = alertDescription
        
        // MARK: - Colors
        titleLabel.textColor =  colorProvider.appTitleColor
        descriptionLabel.textColor = colorProvider.appDefaultTextColor
        
        // MARK: - Fonts
        titleLabel.font = AppFont.bold.withSize(17)
        descriptionLabel.font = AppFont.regular.withSize(15)
        
        // MARK: - Layout
        
        alertContentView.layer.cornerRadius = 10
        alertContentView.layer.opacity = 0.95
        checkImageView.image = imageProvider.checkInfoIcon
    }
    
    // MARK: - Actions
    @IBAction func okAction(_ sender: Any) {
        okAction()
    }
}
