//
//  DeleteWalletWarningViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/12/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import Foundation
import EssCore
import EssModel
import EssResources

class DeleteWalletWarningViewController: QuestionAlertViewController {
    private var wallet: ViewWalletInterface
    
    init(wallet: ViewWalletInterface, leftAction: @escaping () -> Void, rightAction: @escaping () -> Void) {
        self.wallet = wallet
        super.init(leftAction: leftAction, rightAction: rightAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyTitles()
    }

    private func applyTitles() {
        imageView.image = (inject() as AppImageProviderInterface).warningIcon
        titleLabel.text = LS("Wallet.Options.Delete.Warning.Title")
        let attributedTitle: NSMutableAttributedString = NSMutableAttributedString()
        let defaultFont = AppFont.regular.withSize(14)
        attributedTitle.append(NSAttributedString(string: LS("Wallet.Options.Delete.Warning.Description1"), attributes: [NSAttributedString.Key.font: defaultFont]))
        attributedTitle.append(NSAttributedString(string: " ", attributes: [:]))
        attributedTitle.append(NSAttributedString(string: wallet.name, attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(14)]))
        attributedTitle.append(NSAttributedString(string: " ", attributes: [:]))
        attributedTitle.append(NSAttributedString(string: LS("Wallet.Options.Delete.Warning.Description2"), attributes: [NSAttributedString.Key.font: defaultFont]))
        descriptionLabel.attributedText = attributedTitle
        leftButton.setTitle(LS("Wallet.Options.Delete.Warning.Cancel"), for: .normal)
        rightButton.setTitle(LS("Wallet.Options.Delete.Warning.Delete"), for: .normal)
        leftButton.setTitleColor((inject() as AppColorInterface).appDefaultTextColor, for: .normal)
        rightButton.setTitleColor((inject() as AppColorInterface).balanceChangedMinus, for: .normal)
    }
}
