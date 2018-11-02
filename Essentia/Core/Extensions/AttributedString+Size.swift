//
//  AttributedString+Size.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/31/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

extension NSAttributedString {
    func height(with: CGFloat) -> CGFloat {
        return boundingRect(with: CGSize(width: with, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).height
    }
}
