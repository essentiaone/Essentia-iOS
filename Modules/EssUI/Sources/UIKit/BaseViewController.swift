//
//  BaseViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

open class BaseViewController: UIViewController, UINavigationControllerDelegate {
    // MARK: - Dependencies
    public lazy var colorProvider: AppColorInterface = inject()
    public lazy var imageProvider: AppImageProviderInterface = inject()
    
    public var keyboardObserver: KeyboardHeightObserver
    public var isKeyboardShown: Bool = false
    public var topView: UIView?
    public var bottomView: UIView?
    
    public init() {
        keyboardObserver = KeyboardHeightObserver()
        super.init(nibName: nil, bundle: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        setupScrollInsets()
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        keyboardObserver.start()
    }
    
    private func setupScrollInsets() {
        let oneViewHeight = view.frame.height / 2
        topView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: oneViewHeight))
        bottomView = UIView(frame: CGRect(x: 0, y: oneViewHeight, width: view.frame.width, height: oneViewHeight))
        topView?.isUserInteractionEnabled = false
        bottomView?.isUserInteractionEnabled = false
    }
    
    override open  func viewWillDisappear(_ animated: Bool) {
        keyboardObserver.stop()
    }
    
    public func showFlipAnimation() {
        guard let mainwindow = UIApplication.shared.delegate?.window as? UIWindow else { return }
        UIView.transition(with: mainwindow, duration: 0.55001, options: .transitionFlipFromLeft, animations: { () -> Void in
        }, completion: { (_) -> Void in})
    }
    
    public func addLastCellBackgroundContents(topColor: UIColor, bottomColor: UIColor) {
        let oneViewHeight = view.frame.height / 2
        topView?.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: oneViewHeight)
        bottomView?.frame = CGRect(x: 0, y: oneViewHeight, width: view.frame.width, height: oneViewHeight)
        topView?.backgroundColor = topColor
        bottomView?.backgroundColor = bottomColor
    }
}
