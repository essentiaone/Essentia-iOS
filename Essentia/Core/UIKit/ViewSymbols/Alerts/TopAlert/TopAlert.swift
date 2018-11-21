//
//  TopAlert.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/19/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum AlertType {
    case error
    case info
    
    var prefixImage: UIImage {
        switch self {
        case .info:
            return UIImage(named: "topAlertInfo")!
        case .error:
            return UIImage(named: "topAlertCancel")!
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

class TopAlert: UIView {
    private var label = UILabel()
    private let alertType: AlertType
    
    init(alertType: AlertType, title: String) {
        self.alertType = alertType
        let screenWidth = UIScreen.main.bounds.width
        switch alertType {
        case .error:
            super.init(frame: CGRect(x: 16, y: -40, width: screenWidth - 32, height: 40))
            setGradientBackground(first: RGB(255, 56, 0), second: RGB(255, 56, 60), type: .topToBottom)
        case .info:
            super.init(frame: CGRect(x: 31, y: 28, width: screenWidth - 62, height: 40))
            backgroundColor = RGB(59, 207, 85)
        }
        applyTitle(title: title, image: alertType.prefixImage)
        applyDesign()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Design
    func applyDesign() {
        clipsToBounds = true
        layer.cornerRadius = 6.0
        label.textAlignment = .center
    }
    
    override func layoutSubviews() {
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
    func show(in view: UIView) {
        frame.size.width = view.frame.width - alertType.insets * 2
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = .moveIn
        self.layer.add(transition, forKey: nil)
        view.addSubview(self)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3) { [weak self] in
            self?.hide()
        }
    }
    
    @objc func hide() {
        setPosition(position: -40, completion: { [weak self] _ in
            self?.removeFromSuperview()
        })
    }
    
    func setPosition(position: CGFloat, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.4, animations: {
            self.frame.origin.y = position
        }, completion: completion)
    }
}
