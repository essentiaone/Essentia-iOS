//
//  UIView+Animation.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/23/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import QuartzCore

extension UIView {
    func animateToColor(_ color: UIColor, with duration: Double = 0.5) {
        UIView.transition(with: self, duration: duration, options: .beginFromCurrentState, animations: {
            self.superview?.layoutSubviews()
            self.backgroundColor = color
        }) { (complition) in
            (inject() as LoggerServiceInterface).log("Color animation completed", level: .info)
        }
    }
}
