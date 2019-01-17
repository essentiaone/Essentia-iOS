//
//  BaseBluredController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/27/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

open class BaseBluredController: BaseViewController {
    public var blureView: UIVisualEffectView
    
    override public  init() {
        self.blureView = UIVisualEffectView(frame: UIScreen.main.bounds)
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open  func viewDidLoad() {
        super.viewDidLoad()
        applyDesign()
    }
    
    private func applyDesign() {
        blureView.effect = UIBlurEffect(style: .light)
        view.addSubview(blureView)
        view.backgroundColor = .clear
        applyConstranints()
    }
    
    private func applyConstranints() {
        [NSLayoutConstraint.Attribute.top, .bottom, .leading, .trailing].forEach {
            view.addConstraint(NSLayoutConstraint(item: blureView, attribute: $0, relatedBy: .equal, toItem: view, attribute: $0, multiplier: 1, constant: 0))
        }
    }

}
