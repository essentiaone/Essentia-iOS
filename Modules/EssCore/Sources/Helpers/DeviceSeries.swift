//
//  DeviceSeries.swift
//  Essentia
//
//  Created by Pavlo Boiko on 20.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

public enum DeviceSeries {
    case iPhone5
    case iPhone6
    case iPhone6Plus
    case iPhoneX
    
    case notAvailable
    
    public static var currentSeries: DeviceSeries {
        switch UIScreen.main.bounds.height {
        case 812:
            return .iPhoneX
        case 736:
            return .iPhone6Plus
        case 667:
            return .iPhone6
        case 568:
            return .iPhone5
        default: return .notAvailable
        }
    }
}
