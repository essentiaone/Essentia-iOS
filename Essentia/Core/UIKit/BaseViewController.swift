//
//  BaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    var keyboardHeight: CGFloat = 0
    var isKeyboardShown: Bool = false
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(BaseViewController.keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let keyboardSize = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        let newKeyboardHeight = keyboardSize.cgRectValue.height
        let shouldNotify = keyboardHeight != newKeyboardHeight
        keyboardHeight = newKeyboardHeight
        isKeyboardShown = keyboardHeight > 0
        if shouldNotify {
            keyboardDidChange()
        }
    }
    
    func keyboardDidChange() {}
    
    func showFlipAnimation() {
        guard let mainwindow = UIApplication.shared.delegate?.window as? UIWindow else { return }
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }) { (_) -> Void in}
    }
}
