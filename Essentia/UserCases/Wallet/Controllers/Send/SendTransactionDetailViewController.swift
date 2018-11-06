//
//  SendTransactionDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/2/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
//

import UIKit
import QRCodeReader

fileprivate struct Store {
    let wallet: ViewWalletInterface
    let ammountToSend: String
    var address: String = ""
    var data: String = ""
    var selectedFeeSlider: Float = 3
    var isFeeEnteringDirectly: Bool = false
    var enteredFee: Double = 0.0025
    
    var qrImage: UIImage? {
        guard address.isEmpty else { return nil }
        return UIImage(named: "qrCode")
    }
    
    var isValidTransaction: Bool {
        return false
    }
    
    init(wallet: ViewWalletInterface, transactionAmmount: String) {
        self.wallet = wallet
        self.ammountToSend = transactionAmmount
    }
    
}

class SendTransactionDetailViewController: BaseTableAdapterController, QRCodeReaderViewControllerDelegate {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    
    private var store: Store
    
    init(wallet: ViewWalletInterface, ammount: String) {
        self.store = Store(wallet: wallet, transactionAmmount: ammount)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.reload(state)
    }
    
/*
     "Wallet.Send.Mins" = "mins";
     "Wallet.Send.hours" = "hours";
     "Wallet.Send.TransactionTime" = "Transaction time";*/
    private var state: [TableComponent] {
        let ammountFormatter = BalanceFormatter(asset: store.wallet.asset)
        return [
            .empty(height: 25, background: colorProvider.settingsCellsBackround),
            .navigationBar(left: LS("Back"),
                           right: "",
                           title: "",
                           lAction: backAction,
                           rAction: nil),
            .attributedTitleDetail(title: NSAttributedString(string: LS("Wallet.Send.Title"),
                                                             attributes: [NSAttributedString.Key.font: AppFont.bold.withSize(28),
                                                                          NSAttributedString.Key.strokeColor: colorProvider.appTitleColor]),
                                   detail: availableBalanceString, action: nil),
            .empty(height: 26, background: colorProvider.settingsCellsBackround),
            .titleCenteredDetail(title: LS("Wallet.Send.Amount"),
                                 detail: ammountFormatter.formattedAmmountWithCurrency(ammount: store.ammountToSend)),
            .separator(inset: .zero),
            .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.To"),
                                                  text: store.address,
                                                  placeholder: LS("Wallet.Send.Required"),
                                                  rightButtonImage: store.qrImage,
                                                  rightButtonAction: readQrAction,
                                                  textFieldChanged: addressEditingChanged),
            .separator(inset: .zero),
            .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.Data"),
                                                  text: store.data,
                                                  placeholder: LS("Wallet.Send.Optional"),
                                                  rightButtonImage: nil,
                                                  rightButtonAction: nil,
                                                  textFieldChanged: dataEditingChanged)]
            + feeComponents +
            [.calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .empty(height: 8, background: colorProvider.settingsCellsBackround),
            isKeyboardShown ? .keyboardInset : .empty(height: 1, background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("Wallet.Send.GenerateTransaction"),
                                          isEnable: store.isValidTransaction,
                                          action: continueAction,
                                          background: colorProvider.settingsCellsBackround),
            .empty(height: 16, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    var feeComponents: [TableComponent] {
        let ammountFormatter = BalanceFormatter(asset: self.store.wallet.asset)
        switch store.isFeeEnteringDirectly {
        case true:
            return [.separator(inset: .zero),
                    .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.Fee"),
                                                          text:ammountFormatter.formattedAmmount(amount: store.enteredFee),
                                                          placeholder: self.store.wallet.asset.symbol,
                                                          rightButtonImage: nil,
                                                          rightButtonAction: nil,
                                                          textFieldChanged: feeChangedDirectly)]
        case false:
            return [.attributedTitleDetail(title: formattedFeeTitle, detail: formattedInputFeeButton, action: inputFeeAction),
                    .slider(titles: (LS("Wallet.Send.Slow"), LS("Wallet.Send.Normal"), LS("Wallet.Send.Fast")),
                                selected: Float(store.selectedFeeSlider), didChange: feeChanged)]
        }
    }
    
    // MARK: - Formatters
    var availableBalanceString: NSAttributedString {
        let availableString = NSMutableAttributedString()
        availableString.append(NSAttributedString(string: LS("Wallet.Send.Available") + ": ",
                                                  attributes: titleAttributes))
        availableString.append(NSAttributedString(string: self.store.wallet.formattedBalance,
                                                  attributes: titleAttributes))
        availableString.append(NSAttributedString(string: " "))
        availableString.append(NSAttributedString(string: self.store.wallet.asset.symbol,
                                                  attributes: titleAttributes))
        return availableString
    }
    
    var formattedFeeTitle: NSAttributedString {
        let string = LS("Wallet.Send.Fee") + "(0.000125BTC)"
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                                                               NSAttributedString.Key.foregroundColor: colorProvider.titleColor])
    }

    var formattedInputFeeButton: NSAttributedString {
        return NSAttributedString(string: LS("Wallet.Send.InputFee"),
                                  attributes: [NSAttributedString.Key.font: AppFont.regular.withSize(12),
                                               NSAttributedString.Key.foregroundColor: colorProvider.centeredButtonBackgroudColor])
    }
    
    var titleAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                NSAttributedString.Key.foregroundColor: colorProvider.titleColor]
    }
    // MARK: - Actions
    private lazy var backAction: () -> Void = {
        self.view.endEditing(true)
        self.router.pop()
    }
    
    private lazy var continueAction: () -> Void = {
        
    }
    
    private lazy var inputFeeAction: () -> Void = { [weak self] in
        guard let `self` = self else { return }
        self.store.isFeeEnteringDirectly = true
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var readQrAction: () -> Void = {
        self.router.show(.qrReader(self))
    }
    
    private lazy var addressEditingChanged: (String) -> Void = { [weak self] address in
        guard let `self` = self else { return }
        self.store.address = address
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var dataEditingChanged: (String) -> Void = { [weak self] data in
        guard let `self` = self else { return }
        self.store.data = data
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var feeChanged: (Float) -> Void = { [weak self] fee in
        guard let `self` = self else { return }
        self.store.selectedFeeSlider = fee
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var feeChangedDirectly: (String) -> Void = { [weak self] fee in
        guard let `self` = self else { return }
        self.store.enteredFee = Double(fee) ?? 0
        self.tableAdapter.simpleReload(self.state)
    }
    
    // MARK: - QRCodeReaderViewControllerDelegate (Move to wrapper class)
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        dismiss(animated: true)
        print(result)
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        dismiss(animated: true)
    }
}
