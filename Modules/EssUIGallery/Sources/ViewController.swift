//
//  ViewController.swift
//  EssUIGallery
//
//  Created by Pavlo Boiko on 1/23/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import EssUI
import UIKit

fileprivate var titleLabel = "Title"
fileprivate var subtitleLabel = "Subtitle"
fileprivate var buttonLabel = "Button"
fileprivate var titleColor = UIColor.darkText
fileprivate var backgroud = UIColor.white

class ViewController: BaseTableAdapterController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableAdapter.hardReload(state)
    }
    
    override var state: [TableComponent] {
        return [
            // MARK: - Account Strength
            .accountStrength(backAction: action, currentLevel: 0),
            .empty(height: 15, background: .red),
            .accountStrength(backAction: action, currentLevel: 1),
            .empty(height: 15, background: .red),
            .accountStrength(backAction: action, currentLevel: 2),
            .empty(height: 15, background: .red),
            .accountStrength(backAction: action, currentLevel: 3),
            .empty(height: 15, background: .green),
            .accountStrengthAction(action: action, status: .idle, currentLevel: 0),
            .empty(height: 15, background: .red),
            .accountStrengthAction(action: action, status: .idle, currentLevel: 1),
            .empty(height: 15, background: .red),
            .accountStrengthAction(action: action, status: .idle, currentLevel: 2),
            .empty(height: 15, background: .red),
            .accountStrengthAction(action: action, status: .idle, currentLevel: 3),
            .empty(height: 15, background: .green),
            .empty(height: 15, background: .red),
            .title(bold: true, title: titleLabel),
            .empty(height: 15, background: .red),
            .title(bold: false, title: titleLabel),
            .empty(height: 15, background: .green),
            .description(title: titleLabel, backgroud: .white),
            .empty(height: 15, background: .red),
            .description(title: titleLabel, backgroud: .blue),
            .empty(height: 15, background: .green),
            .actionCenteredButton(title: titleLabel, action: action, textColor: .blue, backgrount: backgroud),
            .empty(height: 15, background: .red),
            .actionCenteredButton(title: buttonLabel, action: action, textColor: .red, backgrount: .lightGray),
            .empty(height: 15, background: .green),
            .balanceChanging(balanceChanged: "20", perTime: "24h", action: action),
            .empty(height: 15, background: .red),
            .balanceChanging(balanceChanged: "10", perTime: "12h", action: action),
            .empty(height: 15, background: .green),
            .checkBox(state: ComponentState(defaultValue: true), titlePrifex: "Prefix", title: titleLabel, subtitle: subtitleLabel, action: action),
            .empty(height: 15, background: .red),
            .checkBox(state: ComponentState(defaultValue: false), titlePrifex: "Prefix", title: titleLabel, subtitle: subtitleLabel, action: action)
        ]
    }
    
    // MARK: - Action
    lazy var action: () -> Void = {
        print("Action")
    }
}
