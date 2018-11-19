//
//  DoneTransactionViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class DoneTransactionViewController: BaseViewController {
    @IBOutlet weak var animationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: BaseButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var buttomViewContstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.showBankAnimation()
    }
    
    private func applyDesign() {
        continueButton.drawCornerRadius()
        continueButton.setFont()
        titleLabel.text = LS("Wallet.Transaction.Send.Done.Title")
        detailLabel.text = LS("Wallet.Transaction.Send.Done.Description")
        continueButton.setTitle(LS("Wallet.Transaction.Send.Done.Continue"), for: .normal)
        
        view.backgroundColor = .white
        titleLabel.textColor = .white
        detailLabel.textColor = .white
        continueButton.backgroundColor = .white
        continueButton.setTitleColor(RGB(59, 207, 85), for: .normal)
        titleLabel.font = AppFont.bold.withSize(42)
        detailLabel.font = AppFont.regular.withSize(18)
        
    }
    
    private func showBankAnimation() {
        let animation = PNGAnimation.sendTx
        let player = PNGAnimationPlayer(animation: animation, in: animationImageView)
        player.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animation.animationDuration - 0.63) {
            UIView.animate(withDuration: 0.63, animations: {
                self.buttomViewContstraint.constant = 0
                self.view.backgroundColor = RGB(59, 207, 85)
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
