//
//  TableComponentTextView.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssDI
import EssResources

class TableComponentTextView: UITableViewCell, NibLoadable, UITextViewDelegate {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var placeholderTopConstraint: NSLayoutConstraint!
    
    var textFieldAction: ((String) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyDesign()
    }
    
    func applyDesign() {
        placeholderLabel.font = AppFont.regular.withSize(12)
        textView.font = AppFont.regular.withSize(14)
        textView.textColor = (inject() as AppColorInterface).appTitleColor
        textView.delegate = self
    }
    
    func updatePlaceholderPosition() {
        if textView.text == "" {
            setToCenter()
        }
    }
    
    // MARK: - UITextFieldDelegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        setToTop()
    }
    
    func textViewDidChange(_ textView: UITextView) {
        textFieldAction?(textView.text!)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        updatePlaceholderPosition()
    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        textView.isUserInteractionEnabled = false
        return true
    }
    
    func setToCenter() {
        let centerOfScreen = (frame.height/2) - 8
        animatePlaceholder(size: 16, position: centerOfScreen)
    }
    
    func setToTop() {
        animatePlaceholder(size: 12, position: 6)
    }
    
    func animatePlaceholder(size: CGFloat, position: CGFloat) {
        UIView.animate(withDuration: 0.2) {
            self.placeholderLabel.font = AppFont.regular.withSize(size)
            self.placeholderTopConstraint.constant = position
            self.layoutIfNeeded()
        }
    }
}
