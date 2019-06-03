//
//  FullSecuredViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/13/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssModel
import EssResources
import EssUI
import EssDI

class FullSecuredViewController: BaseTableAdapterController {
    
    // MARK: - Dependences
    private lazy var userStorage: UserStorageServiceInterface = inject()
    
    var isAnimationShow: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
        showBankAnimation()
    }
    
    // MARK: - State
    override var state: [TableComponent] {
        let animationHeight = UIScreen.main.bounds.height - 300
        return [.empty(height: 20, background: .clear),
                .animation(.securing99toSafe, height: animationHeight),
                .calculatbleSpace(background: .clear)] +
        buttonsState
    }
    
    private var buttonsState: [TableComponent] {
        if !isAnimationShow { return [] }
        return [
            .titleWithFontAligment(font: AppFont.bold.withSize(42),
                                   title: LS("Settings.FullSecured.Title"),
                                   aligment: .center,
                                   color: .white),
            .titleWithFontAligment(font: AppFont.regular.withSize(18),
                                   title: LS("Settings.FullSecured.Description"),
                                   aligment: .center,
                                   color: .white),
            .empty(height: 30, background: .clear),
            .actionCenteredButton(title: LS("Settings.FullSecured.Continue"),
                                  action: continueAction,
                                  textColor: .black,
                                  backgrount: .white),
            .empty(height: 24, background: .clear)
        ]
    }
    
    private func applyDesign() {
        tableView.backgroundColor = RGB(59, 207, 85)
        tableView.bounces = false
        tableView.isScrollEnabled = false
    }
    
    
    private func showBankAnimation() {
        let animation = PNGAnimation.securing99toSafe
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animation.animationDuration - 0.63) { [unowned self] in
            self.isAnimationShow.toggle()
            self.tableAdapter.performTableUpdate(newState: self.state, withAnimation: .toTop)
            self.tableView.isScrollEnabled = false
        }
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        self.userStorage.update({ (user) in
            user.userEvents?.isAccountFullySecuredShown = true
        })
        self.navigationController?.popViewController(animated: true)
    }
}
