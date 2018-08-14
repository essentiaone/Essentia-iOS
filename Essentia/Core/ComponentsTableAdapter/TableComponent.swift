//
//  TableComponent.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum TableComponent: Equatable {
    // MARK: - Common
    case separator(inset: UIEdgeInsets)
    case empty(height: CGFloat, background: UIColor)
    case title(title: String)
    case description(title: String)
    // MARK: - Settings
    case accountStrength(progress: Int, backAction: () -> Void)
    case accountStrengthAction(progress: Int, action: () -> Void)
    case currentAccount(icon: UIImage, title: String, name: String, action: () -> Void)
    case menuTitleDetail(icon: UIImage, title: String, detail: String, action: () -> Void)
    case menuSwitch(icon: UIImage, title: String, state: ComponentState<Bool>, action: (Bool) -> Void)
    case menuButton(title: String, color: UIColor, action: () -> Void)
    case strengthField(state: ComponentState<Bool>, title: String, detail: String)
    case plainText(title: String)
    
    // MARK: - Equatable
    static func==(lhs: TableComponent, rhs: TableComponent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    var rawValue: String {
        return String(describing: self)
    }
}
