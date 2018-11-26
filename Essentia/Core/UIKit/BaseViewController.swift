//
//  BaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController, UINavigationControllerDelegate {
    var keyboardObserver: KeyboardHeightObserver
    var isKeyboardShown: Bool = false
    
    public init() {
        keyboardObserver = KeyboardHeightObserver()
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
        keyboardObserver.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        keyboardObserver.stop()
    }
    
    func showFlipAnimation() {
        guard let mainwindow = UIApplication.shared.delegate?.window as? UIWindow else { return }
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }, completion: { (_) -> Void in})
    }
}
