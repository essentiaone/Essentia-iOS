//
//  AppColorInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

protocol AppColorInterface {
    var appBackgroundColor: UIColor { get }
    var appTitleColor: UIColor { get }
    var appDefaultTextColor: UIColor { get }
    var appLinkTextColor: UIColor { get }
    var centeredButtonBackgroudColor: UIColor { get }
    var centeredButtonDisabledBackgroudColor: UIColor { get }
    var centeredButtonTextColor: UIColor { get }
    var borderedButtonTextColor: UIColor { get }
    var borderedButtonBorderColor: UIColor { get }
    var copyButtonBackgroundDeselectedColor: UIColor { get }
    var copyButtonBackgroundSelectedColor: UIColor { get }
    var copyButtonTextColor: UIColor { get }
}
