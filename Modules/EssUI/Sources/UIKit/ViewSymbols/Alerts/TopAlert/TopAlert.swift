//
//  TopAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssModel
import EssDI
import EssResources

public enum AlertType {
    case error
    case info
    
    var prefixImage: UIImage {
        switch self {
        case .info:
            return (inject() as AppImageProviderInterface).topAlertInfo
        case .error:
            return (inject() as AppImageProviderInterface).topAlertCancel
        }
    }
    
    var insets: CGFloat {
        switch self {
        case .info:
            return 31.0
        case .error:
            return 16.0
        }
    }
    
    var backgroundColor: UIColor {
        switch self {
        case .error:
            return (inject() as AppColorInterface).alertErrorColor
        case .info:
            return (inject() as AppColorInterface).alertInfoColor
        }
    }
    
    func attributedTitle(_ message: String) -> NSAttributedString {
        let font = AppFont.medium.withSize(14)
        let fullString = NSMutableAttributedString()
        let prefixImageAtachment = NSTextAttachment()
        prefixImageAtachment.bounds = CGRect(x: 0, y: (font.capHeight - prefixImage.size.height).rounded() / 2,
                                    width: prefixImage.size.width, height: prefixImage.size.height)
        prefixImageAtachment.image = prefixImage
        
        let text = NSAttributedString(string: message, attributes: [NSAttributedString.Key.font: font,
                                                                  NSAttributedString.Key.foregroundColor: UIColor.white])
        let imageString = NSAttributedString(attachment: prefixImageAtachment)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "   "))
        fullString.append(NSAttributedString(attributedString: text))
        return fullString
    }
}

public class TopAlert: UIView {
    private var label = UILabel()
    private let alertType: AlertType
    private var isAnimating: Bool = false
    private var containerView: UIView
    
    public init(alertType: AlertType, title: String, inView: UIView) {
        self.containerView = inView
        self.alertType = alertType
        super.init(frame: CGRect(x: alertType.insets, y: -40, width: inView.frame.width - alertType.insets * 2, height: 40))
        backgroundColor = alertType.backgroundColor
        label.attributedText = alertType.attributedTitle(title)
        addSubview(label)
        applyDesign()
        inView.addSubview(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Design
    func applyDesign() {
        clipsToBounds = true
        layer.cornerRadius = 6.0
        label.textAlignment = .center
    }
    
    override open  func layoutSubviews() {
        super.layoutSubviews()
        label.frame = bounds
    }
    
    // MARK: - Actions
    public func show() {
        guard !isAnimating else { return }
        isAnimating = true
        frame.origin.y = -40
        setPosition(position: 28, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
            self?.hide()
        }
    }
    
    @objc func hide() {
        isAnimating = false
        setPosition(position: -40, completion: nil)
    }
    
    public func setPosition(position: CGFloat, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.4, animations: {
            self.frame.origin.y = position
        }, completion: completion)
    }
}
