//
//  TableAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit

class TableAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Dependences
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - State
    private var tableState: [TableComponent] = []
    private var tableView: UITableView
    private var helper: TableAdapterHelper
    
    // MARK: - Init
    public init(tableView: UITableView) {
        self.tableView = tableView
        self.helper = TableAdapterHelper(tableView: tableView)
        super.init()
        setupTableView()
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.contentInsetAdjustmentBehavior = .never
        registerCells()
    }
    
    func registerCells() {
        tableView.register(TableComponentEmpty.self)
        tableView.register(TableComponentSeparator.self)
        tableView.register(TableComponentTitle.self)
        tableView.register(TableComponentDescription.self)
        tableView.register(TableComponentAccountStrengthAction.self)
        tableView.register(TableComponentAccountStrength.self)
        tableView.register(TableComponentTitleDetail.self)
        tableView.register(TableComponentSwitch.self)
        tableView.register(TableComponentMenuButton.self)
        tableView.register(TableComponentCurrentAccount.self)
        tableView.register(TableComponentCheckBox.self)
        tableView.register(TableComponentDescription.self)
        tableView.register(TableComponentParagraph.self)
        tableView.register(TableComponentNavigationBar.self)
        tableView.register(TableComponentCenteredButton.self)
        tableView.register(TableComponentPassword.self)
        tableView.register(TableComponentCheckField.self)
        tableView.register(TableComponentImageTitle.self)
    }
    
    // MARK: - Update State
    public func simpleReload(_ state:[TableComponent]) {
        let oldState = self.tableState
        self.tableState = state
        UIView.setAnimationsEnabled(false)
        tableView.beginUpdates()
        for step in Dwifft.diff(oldState, state) {
            switch step {
            case .insert(let rowIndex, _):
                tableView.insertRows(at: [IndexPath(row: rowIndex, section: 0)], with: .none)
            case .delete(let rowIndex, _):
                tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)], with: .none)
            }
        }
        tableView.endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func reload(_ state: [TableComponent]) {
        self.tableState = state
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableState.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableState[indexPath.row] {
        case .empty(_, let background):
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = background
            return cell
        case .separator(let inset):
            let cell: TableComponentSeparator = tableView.dequeueReusableCell(for: indexPath)
            cell.separatorInset = inset
            return cell
        case .title(let title):
            let cell: TableComponentTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            return cell
        case .description(let title, let backgroud):
            let cell: TableComponentDescription = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.backgroundColor = backgroud
            return cell
        case .calculatbleSpace(let background):
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = background
            return cell
        case .accountStrengthAction(let progress, let action):
            let cell: TableComponentAccountStrengthAction = tableView.dequeueReusableCell(for: indexPath)
            cell.resultAction = action
            cell.progress = progress
            return cell
        case .accountStrength(let progress, let backAction):
            let cell: TableComponentAccountStrength = tableView.dequeueReusableCell(for: indexPath)
            cell.progress = progress
            cell.resultAction = backAction
            return cell
        case .menuTitleDetail(let icon, let title, let detail, _):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            cell.imageView?.image = icon
            return cell
        case .menuSwitch(let icon, let title, let state, let action):
            let cell: TableComponentSwitch = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.imageView?.image = icon
            cell.switchView.isOn = state.value
            cell.action = action
            return cell
        case .menuButton(let title, let color, _):
            let cell: TableComponentMenuButton = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.textLabel?.textColor = color
            return cell
        case .currentAccount(let icon, let title, let name, _):
            let cell: TableComponentCurrentAccount = tableView.dequeueReusableCell(for: indexPath)
            cell.accountImageView.image = icon
            cell.accountTitleLabel.text = title
            cell.accountDescription.text = name
            return cell
        case .checkBox(let state, let titlePrefix, let title, let  subtitle, _):
            let cell: TableComponentCheckBox = tableView.dequeueReusableCell(for: indexPath)
            cell.setAttributesTitle(regularPrefix: titlePrefix, attributedSuffix: title)
            cell.descriptionLabel.text = subtitle
            cell.imageView?.image = state.value ? imageProvider.checkBoxFilled : imageProvider.checkBoxEmpty
            return cell
        case .centeredButton(let title, let isEnable, let action):
            let cell: TableComponentCenteredButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setTitle(title, for: .normal)
            cell.setEnable(isEnable)
            cell.action = action
            return cell
        case .navigationBar(let left, let right, let title, let lAction,let rAction):
            let cell: TableComponentNavigationBar = tableView.dequeueReusableCell(for: indexPath)
            cell.leftButton.setTitle(left, for: .normal)
            cell.rightButton.setTitle(right, for: .normal)
            cell.titleLabel.text = title
            cell.leftAction = lAction
            cell.rightAction = rAction
            return cell
        case .paragraph(let title, let description):
            let cell: TableComponentParagraph = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.descriptionLabel.text = description
            return cell
        case .password(let passwordAction):
            let cell: TableComponentPassword = tableView.dequeueReusableCell(for: indexPath)
            cell.passwordAction = passwordAction
            return cell
        case .tabBarSpace: fallthrough
        case .keyboardInset:
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = .clear
            return cell
        case .menuTitleCheck(let title, let state, _):
            let cell: TableComponentCheckField = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.checkImageView.image = state.value ?! imageProvider.checkIcon
            return cell
        case .imageTitle(let image,let title, let withArrow, _):
            let cell: TableComponentImageTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImage?.image = image
            cell.titleLabel.text = title
            cell.accessoryType = withArrow ? .disclosureIndicator : .none
            return cell
        default:
            fatalError()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let component = tableState[indexPath.row]
        switch component {
        case .separator:
            return 1.0
        case .empty(let height, _):
            return height
        case .title(let title):
            return title.multyLineLabelHeight(with: AppFont.bold.withSize(34), width: tableView.frame.width)
        case .description(let title, _):
            return title.multyLineLabelHeight(with: AppFont.regular.withSize(14.0), width: tableView.frame.width - 30) + 4
        case .calculatbleSpace:
            return helper.heightForEmptySpace(with: tableState, in: self)
        case .accountStrength:
            return 286.0
        case .accountStrengthAction:
            return 394.0
        case .menuButton: fallthrough
        case .menuSwitch: fallthrough
        case .menuTitleDetail:
            return 44.0
        case .currentAccount:
            return 91.0
        case .checkBox:
            return 92.0
        case .centeredButton:
            return 75.0
        case .navigationBar:
            return 44
        case .password:
            return 76.0
        case .paragraph(let title, let description):
            let labelWidth = tableView.frame.width - 43
            return title.multyLineLabelHeight(with: AppFont.bold.withSize(18),
                                              width: labelWidth) +
                   description.multyLineLabelHeight(with: AppFont.regular.withSize(17),
                                                    width: labelWidth) + 20
        case .keyboardInset:
            return DeviceSeries.currentSeries == .iPhoneX ? 280 : 200.0
        case .tabBarSpace:
            return DeviceSeries.currentSeries == .iPhoneX ? 69.0 : 40.0
        case .menuTitleCheck:
            return 44.0
        case .imageTitle:
            return 60.0
        default:
            fatalError()
        }
    }
    
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let component = tableState[indexPath.row]
        switch component {
        case .currentAccount: fallthrough
        case .menuButton: fallthrough
        case .menuTitleDetail: fallthrough
        case .menuTitleCheck: fallthrough
        case .imageTitle: fallthrough
        case .checkBox:
            return true
        default:
            return false
        }
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let component = tableState[indexPath.row]
        switch component {
        case .menuButton(_, _, let action):
            action()
        case .menuTitleDetail(_, _, _, let action):
            action()
        case .currentAccount(_, _, _, let action):
            action()
        case .checkBox(_, _, _, _, let action):
            action()
        case .menuTitleCheck(_, _, let action):
            action()
        case .imageTitle(_, _, _,let action):
            action()
        default:
            return
        }
    }
}
