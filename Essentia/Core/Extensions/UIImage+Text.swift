//
//  UIImage+Text.swift
//  Essentia
//
//  Created by Pavlo Boiko on 15.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

extension UIImage {
    static func image(text: String, size: CGSize, color: UIColor, backgroud: UIColor) -> UIImage {
        let image = UIImage.withColor(backgroud, size: size)
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        
        let textFontAttributes = [
            NSAttributedStringKey.font: AppFont.bold.withSize(size.height/2),
            NSAttributedStringKey.foregroundColor: color
            ] as [NSAttributedStringKey : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: CGPoint(x: size.height/3, y: size.height/5), size: size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext() ?? UIImage()
        UIGraphicsEndImageContext()
        return newImage
    }
}
