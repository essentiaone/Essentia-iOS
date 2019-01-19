//
//  UIView+Gradient.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/20/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public enum GradientType {
    case leftToRight
    case topToBottom
    
    public var startPoint: CGPoint {
        switch self {
        case .leftToRight:
            return CGPoint(x: 0.0, y: 1.0)
        case .topToBottom:
            return CGPoint(x: 1.0, y: 0.0)
        }
    }
    
    public var endPoint: CGPoint {
        switch self {
        case .leftToRight:
            return CGPoint(x: 1.0, y: 1.0)
        case .topToBottom:
            return CGPoint(x: 1.1, y: 1.0)
        }
    }
    
    public func gradientLayer(first: UIColor, second: UIColor, size: CGSize) -> CAGradientLayer {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = [first.cgColor, second.cgColor]
        gradientLayer.frame.size = size
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        return gradientLayer
    }
}

public extension UIView {
    func setGradientBackground(first: UIColor, second: UIColor, type: GradientType) {
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = self.frame.size
        gradientLayer.colors = [first.cgColor, second.cgColor]
        gradientLayer.startPoint = type.startPoint
        gradientLayer.endPoint = type.endPoint
        layer.addSublayer(gradientLayer)
    }
}
