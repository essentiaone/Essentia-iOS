//
//  AppFont.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

fileprivate struct Constants {
    static var reguarFont = "Avenir-Book"
    static var boldFont = "Avenir-Heavy"
    static var lightFont = "Avenir-Light"
    static var mediumFont = "Avenir-Medium"
}

public enum AppFont {
    case regular
    case bold
    case medium
    case light
    
    public func withSize(_ size: CGFloat) -> UIFont {
        guard let font = UIFont(name: fontName, size: size) else {
            fatalError()
        }
        return font
    }
    
    private var fontName: String {
        switch self {
        case .regular:
            return Constants.reguarFont
        case .bold:
            return Constants.boldFont
        case .light:
            return Constants.lightFont
        case .medium:
            return Constants.mediumFont
        }
    }
}
