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
    case slider(titles: (String, String, String), values: (Double, Double, Double), didChange: (Float) -> Void)
    case separator(inset: UIEdgeInsets)
    case empty(height: CGFloat, background: UIColor)
    case shadow(height: CGFloat, shadowColor: UIColor, background: UIColor)
    case title(bold: Bool, title: String)
    case titleWithFont(font: UIFont, title: String, background: UIColor, aligment: NSTextAlignment)
    case titleWithFontAligment(font: UIFont, title: String, aligment: NSTextAlignment, color: UIColor)
    case titleAction(font: UIFont, title: String, action: () -> Void)
    case titleCenteredDetail(title: String, detail: String)
    case description(title: String, backgroud: UIColor)
    case descriptionWithSize(aligment: NSTextAlignment, fontSize: CGFloat, title: String, background: UIColor, textColor: UIColor)
    case textField(placeholder: String, text: String, endEditing: (String) -> Void, isFirstResponder: Bool)
    case textView(placeholder: String, text: String, endEditing: (String) -> Void)
    case imageTitle(image: UIImage, title: String, withArrow: Bool, action: () -> Void)
    case imageUrlTitle(imageUrl: URL, title: String, withArrow: Bool, action: () -> Void)
    case centeredButton(title: String, isEnable: Bool, action: () -> Void, background: UIColor)
    case actionCenteredButton(title: String, action: () -> Void, backgrount: UIColor)
    case smallCenteredButton(title: String, isEnable: Bool, action: () -> Void, background: UIColor)
    case twoButtons(lTitle: String, rTitle: String, lColor: UIColor, rColor: UIColor, lAction:() -> Void, rAction:() -> Void)
    case paragraph(title: String, description: String)
    case pageControl(count: Int, selected: Int)
    case topAlert(alertType: AlertType, title: String)
    // MARK: - Navigation Bar
    case navigationBar(left: String, right: String, title: String, lAction: (() -> Void)?, rAction: (() -> Void)?)
    case rightNavigationButton(title:String, image: UIImage, action: () -> Void)
    case navigationImageBar(left: String, right: UIImage, title: String, lAction: (() -> Void)?, rAction: (() -> Void)?)
    case imageTitleSubtitle(image: UIImage, title: String, subtitle: String)
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
    case password(title: String, withProgress: Bool, passwordAction: (Bool, String) -> Void)
    case centeredImageButton(image: UIImage, action: () -> Void)
    // MARK: - Wallet
    case imageParagraph(image: UIImage, paragraph: String)
    case centeredImage(image: UIImage)
    case centeredImageWithUrl(url: URL, size: CGSize)
    case centeredCorneredImageWithUrl(url: URL, size: CGSize, shadowColor: UIColor)
    case checkImageTitle(imageUrl: URL, title: String, isSelected: Bool, action: () -> Void)
    case search(title: String, placeholder: String, tint: UIColor, backgroud: UIColor, didChange: (String) -> Void)
    case balanceChangingWithRank(rank: NSAttributedString, balanceChanged: String, perTime:String)
    case balanceChanging(balanceChanged: String, perTime:String, action: () -> Void)
    case assetBalance(imageUrl: URL, title: String, value: String, currencyValue: String, action: () -> Void)
    case titleSubtitleDescription(title: String, subtile: String, description: String, action: () -> Void)
    case customSegmentControlCell(titles: [String], selected: Int, action: (Int) -> Void)
    case segmentControlCell(titles: [String], selected: Int, action: (Int) -> Void)
    case filledSegment(titles: [String], action: (Int) -> Void)
    // MARK: - Wallet detail
    case transactionDetail(icon: UIImage, title: String, subtitle: String, description: NSAttributedString, action: () -> Void)
    case searchField(title: String, icon: UIImage, action: () -> Void)
    case titleAttributedDetail(title: String, detail: NSAttributedString)
    case attributedTitleDetail(title: NSAttributedString, detail: NSAttributedString, action: (() -> Void)?)
    case textFieldTitleDetail(string: String, font: UIFont, color: UIColor, detail: NSAttributedString, didChange: (String) -> Void)
    case titleCenteredDetailTextFildWithImage(title: String, text: String, placeholder: String, rightButtonImage: UIImage?,
                                             rightButtonAction: (() -> Void)?, textFieldChanged: (String) -> Void)
    // MARK: - Insets
    case tabBarSpace
    case calculatbleSpace(background: UIColor)
    case centeredComponentTopInstet
    // MARK: - Containers
    case blure(state: [TableComponent])
    case container(state: [TableComponent])
    // MARK: - PoUp
    case titleWithCancel(title: String, action: () -> Void)
    // MARK: - Equatable
    static func==(lhs: TableComponent, rhs: TableComponent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
    
    var rawValue: String {
        return String(describing: self)
    }
}
