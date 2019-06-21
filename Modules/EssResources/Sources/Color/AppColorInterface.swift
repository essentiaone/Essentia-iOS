//
//  AppColorInterface.swift
//  Essentia
//
//  Created by Pavlo Boiko on 12.07.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public protocol AppColorInterface {
    var appBackgroundColor: UIColor { get }
    var appTitleColor: UIColor { get }
    var appDefaultTextColor: UIColor { get }
    var appLinkTextColor: UIColor { get }
    // MARK: - Backup
    var centeredButtonBackgroudColor: UIColor { get }
    var centeredButtonDisabledBackgroudColor: UIColor { get }
    var centeredButtonTextColor: UIColor { get }
    var borderedButtonTextColor: UIColor { get }
    var borderedButtonBorderColor: UIColor { get }
    var copyButtonBackgroundDeselectedColor: UIColor { get }
    var copyButtonBackgroundSelectedColor: UIColor { get }
    var copyButtonTextColor: UIColor { get }
    var blueBorderColor: UIColor { get }
    var currentWordEmpty: UIColor { get }
    var currentWordSelected: UIColor { get }
    var currentWordCurrent: UIColor { get }
    var currentWordEnteringString: UIColor { get }
    var currentWordEnteringPlaceholder: UIColor { get }
    var enteredWordBackgroud: UIColor { get }
    var enteredWordText: UIColor { get }
    var validPasswordIndicator: UIColor { get }
    var notValidPasswordIndicator: UIColor { get }
    var coinsShadowColor: UIColor { get }
    var shamrockColor: UIColor { get }
    var mediumSeaGreenColor: UIColor { get }
    var persianBlueColor: UIColor { get }
    var summerSkyColor: UIColor { get }

    // MARK: - Launchpad
    var launchpadItemTitleColor: UIColor { get }
    var launchpadItemSubTitleColor: UIColor { get }
    // MARK: - TableViewAdapter
    var settingsCellsBackround: UIColor { get }
    var separatorBackgroundColor: UIColor { get }
    var titleColor: UIColor { get }
    var accountStrengthContainerViewBackgroudLowSecure: UIColor { get }
    var accountStrengthContainerViewBackgroudMediumSecure: UIColor { get }
    var accountStrengthContainerViewBackgroudHightSecure: UIColor { get }
    var accountStrengthContainerViewTitles: UIColor { get }
    var accountStrengthContainerViewButtonTitle: UIColor { get }
    var settingsMenuTitle: UIColor { get }
    var settingsMenuSubtitle: UIColor { get }
    var settingsMenuSwitchAccount: UIColor { get }
    var settingsMenuLogOut: UIColor { get }
    var settingsBackgroud: UIColor { get }
    var settingsShadowColor: UIColor { get }
    var balanceChangedPlus: UIColor { get }
    var balanceChangedMinus: UIColor { get }
    var balanceChanged: UIColor { get }
    var segmentControlIndicatorColor: UIColor { get }
    // MARK: - TopAlert
    var alertInfoColor: UIColor { get }
    var alertErrorColor: UIColor { get }
}
