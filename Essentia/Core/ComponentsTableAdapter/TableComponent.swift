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
    case description(title: String, backgroud: UIColor)
    case imageTitle(image: UIImage, title: String, withArrow: Bool, action: () -> Void)
    case centeredButton(title: String, isEnable: Bool, action: () -> Void)
    case navigationBar(left: String, right: String, title: String, lAction: (() -> Void)?, rAction: (() -> Void)?)
    case paragraph(title: String, description: String)
    case calculatbleSpace(background: UIColor)
    // MARK: - Settings
    case accountStrength(progress: Int, backAction: () -> Void)
    case accountStrengthAction(progress: Int, action: () -> Void)
    case currentAccount(icon: UIImage, title: String, name: String, action: () -> Void)
    case menuTitleDetail(icon: UIImage, title: String, detail: String, action: () -> Void)
    case menuSimpleTitleDetail(title: String, detail: String, withArrow: Bool, action: () -> Void)
    case menuTitleCheck(title: String, state: ComponentState<Bool>, action: () -> Void)
    case menuSwitch(icon: UIImage, title: String, state: ComponentState<Bool>, action: (Bool) -> Void)
    case menuSectionHeader(title:String, backgroud: UIColor)
    case menuButton(title: String, color: UIColor, action: () -> Void)
    case checkBox(state: ComponentState<Bool>, titlePrifex: String, title: String, subtitle: String, action: () -> Void)
    case plainText(title: String)
    case password(passwordAction: (Bool, String) -> Void)
    case keyboardInset
    case tabBarSpace
    
    // MARK: - Equatable
    static func==(lhs: TableComponent, rhs: TableComponent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    var rawValue: String {
        return String(describing: self)
    }
}
