//
//  DonePurchaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 6/5/19.
//  Copyright © 2019 Essentia-One. All rights reserved.
//

import EssCore
import EssResources
import EssDI
import EssUI

class DonePurchaseViewController: BaseTableAdapterController {
    private lazy var colorProvider: AppColorInterface = inject()
    
    var isAnimationShow: Bool = false
    var doneAction: (() -> Void)?
    
    init(doneAction: @escaping () -> Void) {
        self.doneAction = doneAction
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var state: [TableComponent] {
        let animationHeight = UIScreen.main.bounds.height - 300
        return [.empty(height: 30, background: .clear),
                .animation(.sendTx, height: animationHeight),
                .calculatbleSpace(background: .clear)] +
        buttonsState
    }
    
    private var buttonsState: [TableComponent] {
        if !isAnimationShow { return [] }
        return [.titleWithFontAligment(font: AppFont.bold.withSize(42),
                                       title: LS("PaidAccount.Done.Title"),
                                       aligment: .center,
                                       color: .white),
                .empty(height: 100, background: .clear),
                .actionCenteredButton(title: LS("PaidAccount.Done.CreateAccount"),
                                      action: continueAction,
                                      textColor: colorProvider.appTitleColor,
                                      backgrount: .white),
                .empty(height: 15, background: .clear)]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
        setupEndAnimationTimer()
    }
    
    private func applyDesign() {
        tableView.backgroundColor = .white
        tableView.bounces = false
        tableView.isScrollEnabled = false
    }
    
    private func setupEndAnimationTimer() {
        let animation = PNGAnimation.sendTx
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + animation.animationDuration - 0.63) { [unowned self] in
            self.isAnimationShow.toggle()
            self.tableAdapter.performTableUpdate(newState: self.state, withAnimation: .toTop)
            self.tableView.isScrollEnabled = false
            let gradient = GradientType.topToBottom.gradientLayer(first: RGB(73, 216, 94), second: RGB(33, 186, 109), size: self.tableView.bounds.size)
            let animation = CABasicAnimation(keyPath: "opacity")
            animation.fromValue = NSNumber(value: 0)
            animation.toValue  = NSNumber(value: 1)
            animation.duration = 0.63
            gradient.add(animation, forKey: "opacity")
            self.tableView.layer.insertSublayer(gradient, at: 0)
            
        }
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        self.dismiss(animated: true, completion: { [unowned self] in
            self.doneAction?()
        })
    }
}
