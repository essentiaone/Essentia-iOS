//
//  UIView+FindSubview.swift
//  Essentia
//
//  Created by Pavlo Boiko on 13.09.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

extension UIView {
    func findView<T>(type: T.Type) -> T? {
        let svs = subviews.flatMap { $0.subviews }
        guard let element = (svs.filter { $0 is T }).first as? T else { return nil }
        return element
    }
}
