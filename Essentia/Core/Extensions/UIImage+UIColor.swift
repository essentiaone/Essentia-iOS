//
//  UIImage+UIColor.swift
//  Essentia
//
//  Created by Pavlo Boiko on 07.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

extension UIImage {
    static func withColor(_ color: UIColor) -> UIImage {
        let size = CGSize(width: 1, height: 1)
        UIGraphicsBeginImageContext(size)
        color.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}
