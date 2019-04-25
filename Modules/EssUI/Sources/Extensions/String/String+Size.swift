//
//  String+Size.swift
//  EssUI
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit

public extension String {
    func singleLineLabelWidth(with font: UIFont) -> CGFloat {
        return self.size(withAttributes: [NSAttributedString.Key.font: font]).width
    }
    
    func multyLineLabelHeight(with font: UIFont, width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect,
                                            options: [.usesLineFragmentOrigin, .usesFontLeading],
                                            attributes: [NSAttributedString.Key.font: font],
                                            context: nil)
        return boundingBox.height
    }
}

public extension NSAttributedString {
    func height(with: CGFloat) -> CGFloat {
        return boundingRect(with: CGSize(width: with, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
    }
}
