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
        switch alertType {
        case .error:
            setGradientBackground(first: RGB(255, 56, 0), second: RGB(255, 56, 60), type: .topToBottom)
        case .info:
            backgroundColor = RGB(59, 207, 85)
        }
        
        applyTitle(title: title, image: alertType.prefixImage)
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
    
    func applyTitle(title: String, image: UIImage) {
        let font = AppFont.medium.withSize(14)
        let fullString = NSMutableAttributedString()
        let prefixImage = NSTextAttachment()
        prefixImage.bounds = CGRect(x: 0, y: (font.capHeight - image.size.height).rounded() / 2, width: image.size.width, height: image.size.height)
        prefixImage.image = image
        
        let text = NSAttributedString(string: title, attributes: [NSAttributedString.Key.font: font,
                                                                  NSAttributedString.Key.foregroundColor: UIColor.white])
        let imageString = NSAttributedString(attachment: prefixImage)
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: "   "))
        fullString.append(NSAttributedString(attributedString: text))
        label.attributedText = fullString
        addSubview(label)
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
