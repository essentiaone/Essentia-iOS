//
//  TableComponentPassword.swift
//  Essentia
//
//  Created by Pavlo Boiko on 21.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentPassword: UITableViewCell, NibLoadable {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordStatusView: UIView!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var passwordStatusLabel: UILabel!
    @IBOutlet weak var passwordVisibleButton: UIButton!
    var isSecure: Bool = true
    
    var passwordAction: ((Bool, String) -> Void)?
    
    // MARK: - Lifecycle
    private lazy var colorProvider: AppColorInterface = inject()
    
    // MARK: - Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
        setPasswordValid(isValid: false)
    }
    
    private func applyDesign() {
        // MARK: - Localized Strings
        passwordTextField.placeholder = LS("Keystore.PasswordField.Placeholder")
        descriptionLabel.text = LS("Keystore.PasswordField.Description")
        passwordStatusLabel.text = LS("Keystore.PasswordField.Status.Good")
        
        // MARK: - Font
        passwordStatusLabel.font = AppFont.regular.withSize(12)
        descriptionLabel.font = AppFont.regular.withSize(12)
        titleLabel.font = AppFont.regular.withSize(17)
        
        // MARK: - Color
        passwordTextField.textColor = colorProvider.appTitleColor
        titleLabel.textColor = colorProvider.appTitleColor
        descriptionLabel.textColor = colorProvider.appTitleColor
        passwordStatusLabel.textColor = colorProvider.validPasswordIndicator
        separatorView.backgroundColor = colorProvider.separatorBackgroundColor
        passwordVisibleButton.setImage((inject() as AppImageProviderInterface).passwordVisible, for: .normal)
        passwordVisibleButton.isSelected = false
        passwordVisibleButton.backgroundColor = .clear
        passwordTextField.isSecureTextEntry = true
        updatePasswordTextField()
        passwordVisibleButton.tintColor = colorProvider.appDefaultTextColor
        
        passwordTextField.addTarget(self, action: #selector(passwordDidChange(_:)), for: .editingChanged)
        passwordStatusView.layer.cornerRadius = 2.0
    }
    
    @objc func passwordDidChange(_ textField: UITextField) {
        let isValid = isValidPassword()
        setPasswordValid(isValid: isValid)
        passwordAction?(isValid, textField.text!)
    }
    
    private func isValidPassword() -> Bool {
         return passwordTextField.text?.count ?? 0 >= 8
    }
    
    private func setPasswordValid(isValid: Bool) {
        passwordStatusLabel.isHidden = !isValid
        let indicatorColor = isValid ? colorProvider.validPasswordIndicator : colorProvider.notValidPasswordIndicator
        passwordStatusView.backgroundColor = indicatorColor
    }
    
    @IBAction func passwordVisibleAction(_ sender: UIButton) {
        isSecure = !isSecure
        passwordTextField.isSecureTextEntry = isSecure
        updatePasswordTextField()
        passwordVisibleButton.tintColor = isSecure ? colorProvider.appDefaultTextColor : colorProvider.appTitleColor
    }
    
    func updatePasswordTextField() {
        if #available(iOS 12.0, *) {
            passwordTextField.textContentType = .oneTimeCode
        } else {
            passwordTextField.textContentType = UITextContentType(rawValue: "")
        }
    }
}
