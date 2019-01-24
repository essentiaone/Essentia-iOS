//
//  UIViewController+DismissKeyboard.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public extension UIViewController {
    private struct AssociatedKey {
        static var hideKeyboardRecognizer = "hideKeyboardRecognizer"
    }
    
    public var hideKeyboardRecognizer: UITapGestureRecognizer! {
        get {
            return objc_getAssociatedObject( self, &AssociatedKey.hideKeyboardRecognizer ) as? UITapGestureRecognizer
        }
        set(newValue) {
            objc_setAssociatedObject( self, &AssociatedKey.hideKeyboardRecognizer, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN )
        }
    }
    
    public func hideKeyboardWhenTappedAround() {
        hideKeyboardRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        hideKeyboardRecognizer.cancelsTouchesInView = false
        view.addGestureRecognizer(hideKeyboardRecognizer)
    }
    
    public func disableEventHideKeyboard() {
        view.removeGestureRecognizer(hideKeyboardRecognizer)
    }
    
    @objc public func dismissKeyboard() {
        view.endEditing(true)
    }
}
