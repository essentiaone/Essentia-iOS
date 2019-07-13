//
//  AppPresentaionAdapter.swift
//  EssCore
//
//  Created by user on 7/11/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import Foundation
import UIKit
import EssDI

public class AppPresentaionAdapter: AppStateEventHandler {
    private lazy var eventProxy: AppStateEventProxyInterface = inject()
    
    private var blurEffectView: UIVisualEffectView?
    private var window: UIWindow?
    
    public init(window: UIWindow?) {
        eventProxy.add(subscriber: self, for : [.willResignActive, .didBecomeActive])
        self.window = window
    }
    
    public func receive(event: AppStates) {
        switch event {
        case .willResignActive:
            blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
            blurEffectView?.frame = UIScreen.main.bounds
            window?.addSubview(blurEffectView ?? UIVisualEffectView())
        case .didBecomeActive:
            UIView.animate(withDuration: 0.3,
                           animations: {
                            self.blurEffectView?.alpha = 0.0},
                           completion: {(value: Bool) in
                            self.blurEffectView?.removeFromSuperview()
            })
        default:
            break
        }
    }
}

