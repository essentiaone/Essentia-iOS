//
//  TableComponent.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

enum TableComponent: Equatable {
    case tableWithHeight(height:CGFloat, state: [TableComponent])
    // MARK: - Common
    case separator(inset: UIEdgeInsets)
    case empty(height: CGFloat, background: UIColor)
    case shadow(height: CGFloat, shadowColor: UIColor, background: UIColor)
    case title(bold: Bool, title: String)
    case titleWithFont(font: UIFont, title: String, background: UIColor)
    case description(title: String, backgroud: UIColor)
    case descriptionWithSize(aligment: NSTextAlignment, fontSize: CGFloat, title: String, background: UIColor)
    case textField(placeholder: String, text: String, endEditing: (String) -> Void)
    case textView(placeholder: String, text: String, endEditing: (String) -> Void)
    case imageTitle(image: UIImage, title: String, withArrow: Bool, action: () -> Void)
    case centeredButton(title: String, isEnable: Bool, action: () -> Void, background: UIColor)
    case smallCenteredButton(title: String, isEnable: Bool, action: () -> Void)
    case navigationBar(left: String, right: String, title: String, lAction: (() -> Void)?, rAction: (() -> Void)?)
    case rightNavigationButton(title:String, image: UIImage, action: () -> Void)
    case paragraph(title: String, description: String)
    case calculatbleSpace(background: UIColor)
    // MARK: - Settings
    case accountStrength(backAction: () -> Void)
    case accountStrengthAction(action: () -> Void)
    case currentAccount(icon: UIImage, title: String, name: String, action: () -> Void)
    case titleSubtitle(title: String, detail: String, action: () -> Void)
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
    // MARK: - Wallet
    case imageParagraph(image: UIImage, paragraph: String)
    case centeredImage(image: UIImage)
    case segmentControlCell(titles: [String], selected: Int, action: (Int) -> Void)
    case checkImageTitle(imageUrl: URL, title: String, isSelected: Bool, action: () -> Void)
    case search(title: String, placeholder: String, tint: UIColor, backgroud: UIColor, didChange: (String) -> Void)
    case balanceChanging(status: ComponentStatus, balanceChanged: String, perTime:String, action: () -> Void)
    case assetBalance(imageUrl: URL, title: String, value: String, currencyValue: String, action: () -> Void)
    case titleSubtitleDescription(title: String, subtile: String, description: String, action: () -> Void)

    // MARK: - Equatable
    static func==(lhs: TableComponent, rhs: TableComponent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    var rawValue: String {
        return String(describing: self)
    }
}
