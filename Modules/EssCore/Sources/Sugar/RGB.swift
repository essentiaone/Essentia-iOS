//
//  RGB.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public func RGB(_ red: UInt8, _ green: UInt8, _ blue: UInt8) -> UIColor {
    return RGB(red, green, blue, alpha: 1.0)
}

public func RGB(_ red: UInt8, _ green: UInt8, _ blue: UInt8, alpha: CGFloat) -> UIColor {
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
}
