//
//  TableAdapter.swift
//  Essentia
//
//  Created by Pavlo Boiko on 10.08.18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import Kingfisher
import EssDI
import EssResources

public class TableAdapter: NSObject, UITableViewDataSource, UITableViewDelegate {
    // MARK: - Dependences
    private lazy var imageProvider: AppImageProviderInterface = inject()
    
    // MARK: - State
    private var tableState: [TableComponent] = []
    private weak var tableView: UITableView!
    var helper: TableAdapterHelper
    private var textEntries: [UIResponder] = []
    private var currentFirstResponder: UIResponder?
    
    private var selectedRow: IndexPath?
    
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
        tableView.register(TableComponentShadow.self)
        tableView.register(TableComponentTextView.self)
        tableView.register(TableComponentSegmentControl.self)
        tableView.register(TableComponentCheckImageTitle.self)
        tableView.register(TableComponentSearch.self)
        tableView.register(TableComponentBalanceChanging.self)
        tableView.register(TableComponentAssetBalance.self)
        tableView.register(TableComponentTitleSubtileDescription.self)
        tableView.register(TableComponentTableView.self)
        tableView.register(TableComponentCustomSegment.self)
        tableView.register(TableComponentTitleImageButton.self)
        tableView.register(TableComponentTransaction.self)
        tableView.register(TableComponentSlider.self)
        tableView.register(TableComponentTitleCenterDetail.self)
        tableView.register(TableComponentTitleCenterTextDetail.self)
        tableView.register(TableComponentTextFieldDetail.self)
        tableView.register(TableComponentImageTitleSubtitle.self)
        tableView.register(TableComponentBlure.self)
        tableView.register(TableComponentContainer.self)
        tableView.register(TableComponentPageControl.self)
        tableView.register(TableComponentTwoButtons.self)
        tableView.register(TableComponentLoader.self)
        tableView.register(TableComponentAnimation.self)
        tableView.register(TableComponentAlert.self)
        tableView.register(TableComponentBorderedButton.self)
        tableView.register(TableComponentButtonWithSubtitle.self)
    }
    
    // MARK: - Update State
    public func simpleReload(_ state: [TableComponent]) {
        UIView.setAnimationsEnabled(false)
        performTableUpdate(newState: state, withAnimation: .none)
        UIView.setAnimationsEnabled(true)
        guard let indexPath = selectedRow else { return }
        tableView(tableView, didSelectRowAt: indexPath)
    }
    
    public func hardReload(_ state: [TableComponent]) {
        self.tableState = state
        tableView.reloadData()
    }
    
    public func performTableUpdate(newState: [TableComponent], withAnimation: TableAdapterAnimation) {
        let oldState = self.tableState
        self.tableState = newState
        tableView.beginUpdates()
        for step in Dwifft.diff(oldState, newState) {
            guard step.idx != selectedRow?.row else { continue }
            switch step {
            case .insert(let rowIndex, _):
                tableView.insertRows(at: [IndexPath(row: rowIndex, section: 0)],
                                     with: withAnimation.insertAnimation(step.value) )
            case .delete(let rowIndex, _):
                tableView.deleteRows(at: [IndexPath(row: rowIndex, section: 0)],
                                     with: withAnimation.deleteAnimation(step.value) )
            }
        }
        tableView.endUpdates()
    }
    
    private func setTableViewInset(_ inset: CGFloat) {
        tableView.setContentOffset(CGPoint(x: 0, y: inset), animated: true)
    }
    
    // MARK: - UITableViewDataSource
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableState.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch tableState[indexPath.row] {
        case .buttonWithSubtitle(let title, let subtitle, let color, let action):
            let cell: TableComponentButtonWithSubtitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.backgroundColor = color
            cell.action = action
            cell.set(title: title, subtitle: subtitle)
            return cell
        case .animation(let animation, _):
            let cell: TableComponentAnimation = tableView.dequeueReusableCell(for: indexPath)
            cell.playAnimation(animation)
            cell.backgroundColor = .clear
            cell.animateImageView.backgroundColor = .clear
            cell.animateImageView.contentMode = .scaleAspectFit
            return cell
        case .alert(let type, let string):
            let cell: TableComponentAlert = tableView.dequeueReusableCell(for: indexPath)
            cell.alertTitle.attributedText = type.attributedTitle(string)
            cell.backgroundColor = type.backgroundColor
            return cell
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
            cell.backgroundColor = .clear
            cell.titleLabel.font = font.withSize(34)
            return cell
        case .titleWithFont(let font, let title, let background, let aligment):
            let cell: TableComponentTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.titleLabel.font = font
            cell.backgroundColor = background
            cell.titleLabel.minimumScaleFactor = 0.5
            cell.titleLabel.textAlignment = aligment
            return cell
        case .titleWithFontAligment(let font, let title, let aligment, let color):
            let cell: TableComponentTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.titleLabel.font = font
            cell.titleLabel.minimumScaleFactor = 0.5
            cell.titleLabel.textAlignment = aligment
            cell.titleLabel.textColor = color
            cell.backgroundColor = .clear
            return cell
        case .descriptionWithSize(let aligment, let fontSize, let title, let backgroud, let textColor):
            let cell: TableComponentDescription = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.backgroundColor = backgroud
            cell.titleLabel.textAlignment = aligment
            cell.titleLabel.textColor = textColor
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
        case .centeredComponentTopInstet:
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = .clear
            return cell
        case .accountStrengthAction(let action, let status, let currentLevel):
            let cell: TableComponentAccountStrengthAction = tableView.dequeueReusableCell(for: indexPath)
            cell.renderState(state: status, secureLevel: currentLevel)
            // TODO: Try refactor
            self.tableState[indexPath.row] = TableComponent.accountStrengthAction(action: action, status: .idle, currentLevel: currentLevel)
            cell.resultAction = action
            return cell
        case .accountStrength(let backAction, let currentLevel):
            let cell: TableComponentAccountStrength = tableView.dequeueReusableCell(for: indexPath)
            cell.updateStatus(securityLevel: currentLevel)
            cell.resultAction = backAction
            return cell
        case .menuSimpleTitleDetail(let title, let detail, let withArrow, _):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.applyDesign()
            cell.textLabel?.text = title
            cell.detailTextLabel?.text = detail
            cell.accessoryType = withArrow ? .disclosureIndicator : .none
            return cell
        case .menuTitleDetail(let icon, let title, let detail, _):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.applyDesign()
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
        case .currentAccount(let userId, let title, let name, _):
            let cell: TableComponentCurrentAccount = tableView.dequeueReusableCell(for: indexPath)
            cell.accountAvatarView.setUser(hash: userId)
            cell.accountTitleLabel.text = title
            cell.accountDescription.text = name
            return cell
        case .checkBox(let state, let titlePrefix, let title, let  subtitle, _):
            let cell: TableComponentCheckBox = tableView.dequeueReusableCell(for: indexPath)
            cell.setAttributesTitle(regularPrefix: titlePrefix, attributedSuffix: title)
            cell.descriptionLabel.text = subtitle
            cell.imageView?.image = state.value ? imageProvider.checkBoxFilled : imageProvider.checkBoxEmpty
            return cell
        case .centeredButton(let title, let isEnable, let action, let background):
            let cell: TableComponentCenteredButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setTitle(title, for: .normal)
            cell.setEnable(isEnable)
            cell.backgroundColor = background
            cell.action = action
            return cell
        case .actionCenteredButton(let title, let action, let textColor, let background):
            let cell: TableComponentCenteredButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setTitle(title, for: .normal)
            cell.titleButton.backgroundColor = background
            cell.action = action
            cell.titleButton.setTitleColor(textColor, for: .normal)
            cell.backgroundColor = .clear
            return cell
        case .attributedCenteredButton(let attributedTitle, let action, let textColor, let background):
            let cell: TableComponentCenteredButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setAttributedTitle(attributedTitle, for: .normal)
            cell.titleButton.backgroundColor = background
            cell.action = action
            cell.titleButton.titleLabel?.textColor = textColor
            cell.backgroundColor = .clear
            return cell
        case .borderedButton(let title, let action, let borderColor, let borderWidth):
            let cell: TableComponentBorderedButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setTitle(title, for: .normal)
            cell.drawBorder(color: borderColor, width: borderWidth)
            cell.action = action
            return cell
        case .navigationBar(let left, let right, let title, let lAction, let rAction):
            let cell: TableComponentNavigationBar = tableView.dequeueReusableCell(for: indexPath)
            if lAction != nil {
                cell.leftButton.setImage(imageProvider.backButtonImage, for: .normal)
            }
            cell.leftButton.setTitle(left, for: .normal)
            cell.rightButton.setTitle(right, for: .normal)
            cell.titleLabel.text = title
            cell.leftAction = lAction
            cell.rightAction = rAction
            return cell
        case .rightNavigationButton(let title, let image, let action):
            let cell: TableComponentNavigationBar = tableView.dequeueReusableCell(for: indexPath)
            cell.rightButton.setImage(image, for: .normal)
            cell.titleLabel.text = title
            cell.rightAction = action
            return cell
        case .navigationImageBar(let left, let right, let title, let lAction, let rAction):
            let cell: TableComponentNavigationBar = tableView.dequeueReusableCell(for: indexPath)
            cell.rightButton.setImage(right, for: .normal)
            cell.leftButton.setImage(imageProvider.backButtonImage, for: .normal)
            cell.leftButton.setTitle(left, for: .normal)
            cell.titleLabel.text = title
            cell.leftAction = lAction
            cell.rightAction = rAction
            return cell
        case .paragraph(let title, let description):
            let cell: TableComponentParagraph = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.descriptionLabel.text = description
            return cell
        case .password(let title, let withProgress, let passwordAction):
            let cell: TableComponentPassword = tableView.dequeueReusableCell(for: indexPath)
            textEntries.append(cell.passwordTextField)
            if !withProgress {
                cell.passwordTextField.becomeFirstResponder()
            }
            cell.passwordAction = passwordAction
            cell.titleLabel.text = title
            return cell
        case .tabBarSpace:
            let cell: TableComponentEmpty = tableView.dequeueReusableCell(for: indexPath)
            cell.backgroundColor = .clear
            return cell
        case .menuTitleCheck(let title, let state, _):
            let cell: TableComponentCheckField = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.checkImageView.image = state.value ? imageProvider.checkIcon : nil
            return cell
        case .imageTitle(let image, let title, let withArrow, _):
            let cell: TableComponentImageTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImage?.image = image
            cell.titleLabel.text = title
            if image.size.width <= cell.titleImage.frame.size.width {
                cell.titleImage.contentMode = .center
            }
            cell.accessoryType = withArrow ? .disclosureIndicator : .none
            return cell
        case .imageUrlTitle(let imageUrl, let title, let withArrow, _):
            let cell: TableComponentImageTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImage.kf.setImage(with: imageUrl)
            cell.titleLabel.text = title
            cell.accessoryType = withArrow ? .disclosureIndicator : .none
            return cell
        case .textField(let placeholder, let text, let endEditing, let isFirstResponder):
            let cell: TableComponentTextField = tableView.dequeueReusableCell(for: indexPath)
            textEntries.append(cell.textField)
            cell.textField.isUserInteractionEnabled = false
            cell.textField.placeholder = placeholder
            cell.textField.text = text
            cell.textFieldAction = endEditing
            if isFirstResponder {
                focusView(view: cell.textField)
                selectedRow = indexPath
            }
            return cell
        case .imageParagraph(let image, let paragraph):
            let cell: TableComponentImageParagraph = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImage.image = image
            cell.titleLabel.text = paragraph
            return cell
        case .smallCenteredButton(let title, let isEnable, let action, let background):
            let cell: TableComponentCenteredButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleButton.setTitle(title, for: .normal)
            cell.setEnable(isEnable)
            let inset = tableView.frame.width / 4
            cell.leftInset.constant = inset
            cell.rightInset.constant = inset
            cell.backgroundColor = background
            cell.action = action
            return cell
        case .centeredImage(let image):
            let cell: TableComponentCenteredImage = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.image = image
            cell.backgroundColor = .clear
            return cell
        case .centeredImageWithCalculatableSpace(let image):
            let cell: TableComponentCenteredImage = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.image = image
            cell.backgroundColor = .clear
            return cell
        case .centeredCorneredImageWithUrl(let url, let size, let color):
            let cell: TableComponentCenteredImage = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.kf.setImage(with: url)
            cell.titleImageView.layer.cornerRadius = size.height
            cell.titleImageView.drawShadow(width: 60, color: color)
            cell.titleImageView.clipsToBounds = false
            cell.verticalInset.constant = 20.0
            cell.verticalInsetBottom.constant = 20.0
            cell.backgroundColor = .clear
            return cell
        case .centeredImageWithUrl(let url, _):
            let cell: TableComponentCenteredImage = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.kf.setImage(with: url)
            cell.backgroundColor = .clear
            return cell
        case .textView(let placeholder,let text, let endEditing):
            let cell: TableComponentTextView = tableView.dequeueReusableCell(for: indexPath)
            textEntries.append(cell.textView)
            cell.placeholderLabel.text = placeholder
            cell.textView.text = text
            cell.textFieldAction = endEditing
            cell.updatePlaceholderPosition()
            return cell
        case .segmentControlCell(let titles, let selected, let action):
            let cell: TableComponentSegmentControl = tableView.dequeueReusableCell(for: indexPath)
            cell.setTitles(titles)
            cell.applySelectableDesign()
            cell.segmentControllerChangedAtIndex = action
            cell.segmentControl.selectedSegmentIndex = selected
            return cell
        case .customSegmentControlCell(let titles, let selected, let action):
            let cell: TableComponentCustomSegment = tableView.dequeueReusableCell(for: indexPath)
            cell.segmentControl.removeAllSegments()
            titles.forEach {
                cell.segmentControl.insertSegment(withTitle: $0, at: cell.segmentControl.numberOfSegments, animated: false)
            }
            cell.selectedIndex = selected
            cell.segmentControl.selectedSegmentIndex = selected
            cell.action = action
            cell.setNeedsLayout()
            return cell
        case .filledSegment(let titles, let action):
            let cell: TableComponentSegmentControl = tableView.dequeueReusableCell(for: indexPath)
            cell.setTitles(titles)
            cell.applyOneColorDesign()
            cell.segmentControllerChangedAtIndex = action
            return cell
        case .twoButtons(let lTitle, let rTitle, let lColor, let rColor, let lAction, let rAction):
            let cell: TableComponentTwoButtons = tableView.dequeueReusableCell(for: indexPath)
            cell.leftButton.setTitle(lTitle, for: .normal)
            cell.rightButton.setTitle(rTitle, for: .normal)
            cell.leftButton.setTitleColor(lColor, for: .normal)
            cell.rightButton.setTitleColor(rColor, for: .normal)
            cell.lAction = lAction
            cell.rAction = rAction
            return cell
        case .checkImageTitle(let imageUrl, let title, let isSelected, _):
            let cell: TableComponentCheckImageTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.kf.setImage(with: imageUrl)
            cell.titleLabel.text = title
            cell.checkImageView.image = isSelected ? imageProvider.checkSelected : imageProvider.checkNotSelected
            return cell
        case .search(let title, let placeholder, let tint, let backgroud, let didChangeString):
            let cell: TableComponentSearch = tableView.dequeueReusableCell(for: indexPath)
            cell.searchBar.isUserInteractionEnabled = false
            cell.searchBar.text = title
            cell.searchBar.placeholder = placeholder
            cell.searchBar.barTintColor = tint
            cell.searchBar.findView(type: UITextField.self)?.backgroundColor = backgroud
            cell.textChangedAction = didChangeString
            return cell
        case .balanceChanging(let balanceChanged, let perTime, let action):
            let cell: TableComponentBalanceChanging = tableView.dequeueReusableCell(for: indexPath)
            cell.procentTitle.text = balanceChanged
            cell.timeUpdateLabel.text = perTime
            cell.action = action
            return cell
        case .balanceChangingWithRank(let rank, let balanceChanged, let perTime):
            let cell: TableComponentBalanceChanging = tableView.dequeueReusableCell(for: indexPath)
            cell.procentTitle.text = balanceChanged
            cell.timeUpdateLabel.text = perTime
            cell.updateButton.isHidden = true
            cell.rankLabel.attributedText = rank
            return cell
        case .assetBalance(let imageUrl, let title, let value, let currencyValue, _):
            let cell: TableComponentAssetBalance = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImage.kf.setImage(with: imageUrl)
            cell.titleLabel.text = title
            cell.balanceTopValue.text = value
            cell.balanceButtomValue.text = currencyValue
            return cell
        case .titleSubtitleDescription(let title, let subtile, let description, _):
            let cell: TableComponentTitleSubtileDescription = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.subtileLabel.text = subtile
            cell.descriptionLabel.text = description
            return cell
        case .tableWithHeight(_, let state):
            let cell: TableComponentTableView = tableView.dequeueReusableCell(for: indexPath)
            cell.tableAdapter.hardReload(state)
            return cell
        case .titleWithCancel(let title, let action):
            let cell: TableComponentTitleImageButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.font = AppFont.bold.withSize(21)
            cell.titleLabel.text = title
            cell.action = action
            return cell
        case .transactionDetail(let icon, let title, let subtitle, let description, _):
            let cell: TableComponentTransaction = tableView.dequeueReusableCell(for: indexPath)
            cell.iconImageView.image = icon
            cell.titleLabel.text = title
            cell.subtileLabel.text = subtitle
            cell.descriptionLabel.attributedText = description
            return cell
        case .searchField(let title, let icon, let action):
            let cell: TableComponentTitleImageButton = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.titleLabel.font = AppFont.bold.withSize(17)
            cell.action = action
            cell.cancelButton.tintColor = (inject() as AppColorInterface).centeredButtonBackgroudColor
            cell.cancelButton.setImage(icon, for: .normal)
            return cell
        case .titleAttributedDetail(let title, let detail):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.applyDesign()
            cell.textLabel?.text = title
            cell.detailTextLabel?.attributedText = detail
            cell.accessoryType = .none
            return cell
        case .attributedTitleDetail(let title, let detail, _):
            let cell: TableComponentTitleDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.textLabel?.attributedText = title
            cell.detailTextLabel?.attributedText = detail
            cell.accessoryType = .none
            return cell
        case .slider(let titles, let values, let didChange):
            let cell: TableComponentSlider = tableView.dequeueReusableCell(for: indexPath)
            cell.leftTitleLabel.text = titles.0
            cell.centerTitleLabel.text = titles.1
            cell.rightTitleLabel.text = titles.2
            cell.slider.value = Float(values.1)
            cell.slider.minimumValue = Float(values.0)
            cell.slider.maximumValue = Float(values.2)
            cell.newSliderAction = didChange
            selectedRow = nil
            return cell
        case .textFieldTitleDetail(let string, let font, let color, let detail, let action):
            let cell: TableComponentTextFieldDetail = tableView.dequeueReusableCell(for: indexPath)
            textEntries.append(cell.titleTextField)
            cell.titleTextField.text = string
            cell.titleTextField.font = font
            cell.titleTextField.textColor = color
            cell.detailLabel.attributedText = detail
            cell.titleTextField.keyboardType = .decimalPad
            cell.enterAction = action
            return cell
        case .titleCenteredDetail(let title, let detail):
            let cell: TableComponentTitleCenterDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.detailLabel.text = detail
            return cell
        case .titleCenteredDetailTextFildWithImage(let title, let text, let placeholder, let rightButtonImage, let rightButtonAction, let textFieldChanged):
            let cell: TableComponentTitleCenterTextDetail = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            textEntries.append(cell.centeredTextField)
            cell.centeredTextField.text = text
            cell.centeredTextField.placeholder = placeholder
            cell.rightButton.setImage(rightButtonImage, for: .normal)
            cell.updateQrButton(text)
            cell.action = rightButtonAction
            cell.enterAction = textFieldChanged
            return cell
        case .imageTitleSubtitle(let image, let title, let subtitle):
            let cell: TableComponentImageTitleSubtitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.subltitle.text = subtitle
            cell.titleImagevView.image = image
            return cell
        case .centeredImageButton(let image, let action):
            let cell: TableComponentCenteredImage = tableView.dequeueReusableCell(for: indexPath)
            cell.titleImageView.image = image
            cell.imageAction = action
            cell.titleImageView.contentMode = .center
            return cell
        case .blure(let state):
            let cell: TableComponentBlure = tableView.dequeueReusableCell(for: indexPath)
            cell.tableAdapter.simpleReload(state)
            return cell
        case .container(let state):
            let cell: TableComponentContainer = tableView.dequeueReusableCell(for: indexPath)
            cell.tableAdapter.simpleReload(state)
            return cell
        case .titleAction(let font, let title, _):
            let cell: TableComponentTitle = tableView.dequeueReusableCell(for: indexPath)
            cell.titleLabel.text = title
            cell.titleLabel.font = font
            return cell
        case .pageControl(let count, let selected):
            let cell: TableComponentPageControl = tableView.dequeueReusableCell(for: indexPath)
            cell.pageControl.currentPage = selected
            cell.pageControl.numberOfPages = count
            return cell
        case .tableWithCalculatableSpace(let state, let background):
            let cell: TableComponentTableView = tableView.dequeueReusableCell(for: indexPath)
            cell.tableAdapter.hardReload(state)
            cell.tableView.backgroundColor = background
            return cell
        case .loader:
            let cell: TableComponentLoader = tableView.dequeueReusableCell(for: indexPath)
            return cell
        }
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return helper.height(for: indexPath, in: tableState)
    }
    
    public func tableView(_ tableView: UITableView, canFocusRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let component = tableState[indexPath.row]
        switch component {
        case .currentAccount: fallthrough
        case .menuButton: fallthrough
        case .menuTitleDetail: fallthrough
        case .menuSimpleTitleDetail: fallthrough
        case .menuTitleCheck: fallthrough
        case .imageTitle: fallthrough
        case .titleSubtitle: fallthrough
        case .textField: fallthrough
        case .textView: fallthrough
        case .checkImageTitle: fallthrough
        case .checkBox: fallthrough
        case .search: fallthrough
        case .titleSubtitleDescription: fallthrough
        case .imageUrlTitle: fallthrough
        case .transactionDetail: fallthrough
        case .textFieldTitleDetail: fallthrough
        case .titleCenteredDetailTextFildWithImage: fallthrough
        case .titleAction: fallthrough
        case .assetBalance:
            return true
        case .attributedTitleDetail(_, _, let action):
            return action != nil
        default:
            return false
        }
    }
    
    // MARK: - UITableViewDelegate
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = nil
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
        case .imageUrlTitle(_, _, _, let action):
            action()
        case .checkImageTitle(_, _, _, let action):
            action()
        case .titleSubtitle(_, _, let action):
            action()
        case .textField:
            let cell: TableComponentTextField = tableView.cellForRow(at: indexPath)
            selectedRow = indexPath
            focusView(view: cell.textField)
        case .textView:
            let cell: TableComponentTextView = tableView.cellForRow(at: indexPath)
            selectedRow = indexPath
            focusView(view: cell.textView)
            cell.setToTop()
        case .search:
            let cell: TableComponentSearch = tableView.cellForRow(at: indexPath)
            selectedRow = indexPath
            focusView(view: cell.searchBar)
        case .assetBalance(_, _, _, _, let action):
            action()
        case .titleSubtitleDescription(_, _, _, let action):
            action()
        case .transactionDetail(_, _, _, _, let action):
            action()
        case .attributedTitleDetail(_, _, let action):
            action?()
        case .textFieldTitleDetail:
            let cell: TableComponentTextFieldDetail = tableView.cellForRow(at: indexPath)
            selectedRow = indexPath
            focusView(view: cell.titleTextField)
        case .titleCenteredDetailTextFildWithImage:
            let cell: TableComponentTitleCenterTextDetail = tableView.cellForRow(at: indexPath)
            selectedRow = indexPath
            focusView(view: cell.centeredTextField)
        case .titleAction(_, _, let action):
            action()
        default:
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func continueEditing() {
        guard let index = selectedRow else { return }
        tableView(tableView, didSelectRowAt: index)
    }
    
    func focusView(view: UIView) {
        view.isUserInteractionEnabled = true
        becomeFirstResponder(view)
    }
    
    public func endEditing(_ force: Bool) {
        self.selectedRow = nil
        self.currentFirstResponder = nil
        self.tableView.endEditing(true)
    }
    
    public func becomeFirstResponder(_ responder: UIResponder) {
        currentFirstResponder = responder
        responder.becomeFirstResponder()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
            self.currentFirstResponder?.becomeFirstResponder()
        }
    }
}
