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
        tableView.register(TableComponentSectionTitle.self)
        tableView.register(TableComponentTextField.self)
        tableView.register(TableComponentImageParagraph.self)
        tableView.register(TableComponentCenteredImage.self)
        tableView.register(TableComponentTitleSubtitle.self)
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
        case .title(let bold, let title):
            let cell: TableComponentTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            let font = bold ? AppFont.bold : AppFont.regular
            cell.titleLabel.font = font.withSize(34)
            return cell
        case .descriptionWithSize(let aligment ,let fontSize,let title,let backgroud):
            let cell: TableComponentDescription = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.backgroundColor = backgroud
            cell.titleLabel.textAlignment = aligment
            cell.titleLabel.font = AppFont.regular.withSize(fontSize)
            return cell
        case .description(let title, let backgroud):
            let cell: TableComponentDescription = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.titleLabel.font = AppFont.regular.withSize(14)
            cell.backgroundColor = backgroud
            return cell
        case .calculatbleSpace(let background):
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = background
            return cell
        case .accountStrengthAction( let action):
            let cell: TableComponentAccountStrengthAction = tableView.dequeueReusableCell(for: indexPath)
            cell.resultAction = action
            return cell
        case .accountStrength(let backAction):
            let cell: TableComponentAccountStrength = tableView.dequeueReusableCell(for: indexPath)
            cell.resultAction = backAction
            return cell
        case .menuSimpleTitleDetail(let title, let detail, let withArrow , _):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            cell.accessoryType = withArrow ? .disclosureIndicator : .none
            return cell
        case .menuTitleDetail(let icon, let title, let detail, _):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            cell.imageView?.image = icon
            return cell
        case .titleSubtitle(let title, let detail, _):
            let cell: TableComponentTitleSubtitle = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            return cell
        case .menuSwitch(let icon, let title, let state, let action):
            let cell: TableComponentSwitch = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.text = title
            cell.imageView?.image = icon
            cell.switchView.isOn = state.value
            cell.action = action
            return cell
        case .menuSectionHeader(let title, let backgroud):
            let cell: TableComponentSectionTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.backgroundColor = backgroud
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
            cell.leftButton.setImage(imageProvider.backButtonImage, for: .normal)
            cell.leftButton.setTitle(left, for: .normal)
            cell.rightButton.setTitle(right, for: .normal)
            cell.titleLabel.text = title
            cell.leftAction = lAction
            cell.rightAction = rAction
            return cell
        case .rightNavigationButton(let image,let action):
            let cell: TableComponentNavigationBar = tableView.dequeueReusableCell(for: indexPath)
            cell.rightButton.setImage(image, for: .normal)
            cell.rightAction = action
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
        case .textField(let placeholder, let text, let endEditing):
            let cell: TableComponentTextField = tableView.dequeueReusableCell(for: indexPath)
            cell.textField.placeholder = placeholder
            cell.textField.text = text
            cell.textFieldAction = endEditing
            return cell
        case .imageParagraph(let image,let paragraph):
            let cell: TableComponentImageParagraph = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImage.image = image
            cell.titleLabel.text = paragraph
            return cell
        case .smallCenteredButton(let title,let isEnable,let action):
            let cell: TableComponentCenteredButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setTitle(title, for: .normal)
            cell.setEnable(isEnable)
            let inset = tableView.frame.width / 4
            cell.leftInset.constant = inset
            cell.rightInset.constant = inset
            cell.action = action
            return cell
        case .centeredImage(let image):
            let cell: TableComponentCenteredImage = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.image = image
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
        case .title(let bold, let title):
            let font = bold ? AppFont.bold : AppFont.regular
            return title.multyLineLabelHeight(with: font.withSize(34), width: tableView.frame.width)
        case .descriptionWithSize(_, let fontSize, let title, _):
            return title.multyLineLabelHeight(with: AppFont.regular.withSize(fontSize), width: tableView.frame.width - 30) + 4
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
        case .menuSimpleTitleDetail: fallthrough
        case .menuTitleDetail:
            return 44.0
        case .currentAccount:
            return 91.0
        case .checkBox:
            return 92.0
        case .smallCenteredButton: fallthrough
        case .centeredButton:
            return 75.0
        case .rightNavigationButton:fallthrough
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
        case .imageTitle: fallthrough
        case .imageParagraph:
            return 60.0
        case .menuSectionHeader:
            return 26.0
        case .textField:
            return 35.0
        case .centeredImage(let image):
            return image.size.height
        case .titleSubtitle:
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
        case .menuSimpleTitleDetail: fallthrough
        case .menuTitleCheck: fallthrough
        case .imageTitle: fallthrough
        case .titleSubtitle: fallthrough
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
        case .menuSimpleTitleDetail(_, _, _, let action):
            action()
        case .currentAccount(_, _, _, let action):
            action()
        case .checkBox(_, _, _, _, let action):
            action()
        case .menuTitleCheck(_, _, let action):
            action()
        case .imageTitle(_, _, _, let action):
            action()
        case .titleSubtitle(_,_, let action):
            action()
        default:
            return
        }
    }
}
