//
//  String+Size.swift
//  Essentia
//
//  Created by Pavlo Boiko on 22.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public extension String {
    public func singleLineLabelWidth(with font: UIFont) -> CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font: font]).width
    }
    
    public func multyLineLabelHeight(with font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
}
