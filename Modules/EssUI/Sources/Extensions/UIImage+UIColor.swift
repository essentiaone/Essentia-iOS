//
//  UIImage+UIColor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public extension UIImage {
    static func withColor(_ color: UIColor, size: CGSize) -> UIImage {
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
    
    static func withColor(_ color: UIColor) -> UIImage {
        return withColor(color, size: CGSize(width: 1, height: 1))
    }
}
