//
//  FullSecuredViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/13/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class FullSecuredViewController: BaseViewController {
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
        titleLabel.text = LS("Settings.FullSecured.Title")
        detailLabel.text = LS("Settings.FullSecured.Description")
        continueButton.setTitle(LS("Settings.FullSecured.Continue"), for: .normal)
        
        view.backgroundColor = RGB(59, 207, 85)
        titleLabel.textColor = .white
        detailLabel.textColor = .white
        continueButton.backgroundColor = .white
        titleLabel.font = AppFont.bold.withSize(42)
        detailLabel.font = AppFont.regular.withSize(18)
        
    }
    
    private func showBankAnimation() {
        let animation = PNGAnimation.securing99toSafe
        let player = PNGAnimationPlayer(animation: animation, in: animationImageView)
        player.play()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animation.animationDuration - 0.63) { [unowned self] in
            UIView.animate(withDuration: 0.63, animations: {
                self.buttomViewContstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func continueAction(_ sender: Any) {
        EssentiaStore.shared.currentUser.userEvents.isAccountFullySecuredShown = true
        (inject() as UserStorageServiceInterface).storeCurrentUser()
        self.navigationController?.popViewController(animated: true)
    }
}
