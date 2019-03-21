//
//  KeyboardHeightObserver.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit

public final class KeyboardHeightObserver: NSObject {
    public typealias AnimationCallback = (_ height: CGFloat) -> Void
    
    let notificationCenter: NotificationCenter
    public var willAnimateKeyboard: AnimationCallback?
    public var animateKeyboard: AnimationCallback?
    public var currentKeyboardHeight: CGFloat?
    
    public override init() {
        notificationCenter = NotificationCenter.default
        super.init()
    }
    
    deinit {
        stop()
    }
    
    public func start() {
        stop()
        notificationCenter.addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(keyboardNotification(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    public func stop() {
        willAnimateKeyboard?(0)
        notificationCenter.removeObserver(self)
    }
    
    // MARK: - Notification
    @objc func keyboardNotification(_ notification: Notification) {
        let isShowing = notification.name == UIResponder.keyboardWillShowNotification
        
        guard
            let userInfo = (notification as NSNotification).userInfo,
            let height = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height,
            let duration: TimeInterval = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let animationCurveRawNSN = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber else
        { return }
        
        let correctedHeight = isShowing ? height : 0
        willAnimateKeyboard?(correctedHeight)
        
        UIView.animate(withDuration: duration,
                       delay: TimeInterval(0),
                       options: UIView.AnimationOptions(rawValue: animationCurveRawNSN.uintValue),
                       animations: { [weak self] in
                        if isShowing && correctedHeight == 0 { return }
                        self?.animateKeyboard?(correctedHeight)
            },
                       completion: nil
        )
        
        currentKeyboardHeight = correctedHeight
    }
}
