//
//  BaseAccountStrengthCell.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10/23/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import EssCore
import EssResources

class BaseAccountStrengthCell: UITableViewCell {
    private lazy var colorProvider: AppColorInterface = inject()
    var currentUserId = EssentiaStore.shared.currentUser.id
    var currentSecurity = EssentiaStore.shared.currentUser.backup.secureLevel
    
    func animationForSecurirtyLevel(_ level: Int) -> PNGAnimation {
        switch level {
        case 2:
            return .securing30to70
        case 3:
            return .securing70to99
        default:
            return .securing0to30
        }
    }
    
    func defaultImageForAnimationPlayer(_ player: PNGAnimationPlayer, for level: Int) -> UIImage? {
        switch level {
        case 0:
            return player.firstImage
        default:
            return player.lastImage
        }
    }
    
    var colorForCurrentSecuringStatus: UIColor {
        switch currentSecurity {
        case 2:
            return colorProvider.accountStrengthContainerViewBackgroudMediumSecure
        case 3:
            return colorProvider.accountStrengthContainerViewBackgroudHightSecure
        default:
            return colorProvider.accountStrengthContainerViewBackgroudLowSecure
        }
    }
}
