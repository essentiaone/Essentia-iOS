//
//  SendLitecoinTransactionViewController.swift
//  EssWallet
//
//  Created by Pavlo Boiko on 3/29/19.
//  Copyright © 2019 Pavlo Boiko. All rights reserved.
//

import UIKit
import HDWalletKit
import QRCodeReader
import EssCore
import EssModel
import EssUI
import EssResources
import EssDI

fileprivate struct Store {
    let wallet: ViewWalletInterface
    let ammount: SelectedTransacrionAmmount
    var address: String = ""
    var selectedFeeSlider: Float = 5
    var isFeeEnteringDirectly: Bool = false
    var lowFee: Double = 1.0
    var fastFee: Double = 30.0
    var keyboardHeight: CGFloat = 0
    var qrImage: UIImage {
        return (inject() as AppImageProviderInterface).qrCode
    }
    
    var isValidTransaction: Bool {
        return wallet.asset.isValidAddress(address)
    }
    
    init(wallet: ViewWalletInterface, transactionAmmount: SelectedTransacrionAmmount) {
        self.wallet = wallet
        self.ammount = transactionAmmount
    }
}

class SendLitecoinTransactionViewController: BaseTableAdapterController, QRCodeReaderViewControllerDelegate {
    // MARK: - Dependences
    private lazy var colorProvider: AppColorInterface = inject()
    private lazy var router: WalletRouterInterface = inject()
    private lazy var interactor: WalletBlockchainWrapperInteractorInterface = inject()
    
    private var store: Store
    
    init(wallet: ViewWalletInterface, ammount: SelectedTransacrionAmmount) {
        self.store = Store(wallet: wallet, transactionAmmount: ammount)
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableAdapter.hardReload(state)
        addLastCellBackgroundContents(topColor: .white, bottomColor: .white)
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
        keyboardObserver.start()
    }
    
    override var state: [TableComponent] {
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
                                 detail: ammountFormatter.formattedAmmountWithCurrency(ammount: store.ammount.inCrypto)),
            .separator(inset: .zero),
            .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.To"),
                                                  text: store.address,
                                                  placeholder: LS("Wallet.Send.Required"),
                                                  rightButtonImage: store.qrImage,
                                                  rightButtonAction: readQrAction,
                                                  textFieldChanged: addressEditingChanged),
            .separator(inset: .zero),
            .calculatbleSpace(background: colorProvider.settingsCellsBackround),
            .empty(height: 8, background: colorProvider.settingsCellsBackround),
            .centeredButton(title: LS("Wallet.Send.GenerateTransaction"),
                            isEnable: store.isValidTransaction,
                            action: continueAction,
                            background: colorProvider.settingsCellsBackround),
            .empty(height: store.keyboardHeight, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    // MARK: - Formatters
    var availableBalanceString: NSAttributedString {
        let availableString = NSMutableAttributedString()
        availableString.append(NSAttributedString(string: LS("Wallet.Send.Available") + ": ",
                                                  attributes: titleAttributes))
        availableString.append(NSAttributedString(string: self.store.wallet.formattedBalance,
                                                  attributes: titleAttributes))
        availableString.append(NSAttributedString(string: " "))
        availableString.append(NSAttributedString(string: self.store.wallet.asset.symbol.uppercased(),
                                                  attributes: titleAttributes))
        return availableString
    }
    
    var titleAttributes: [NSAttributedString.Key: Any] {
        return [NSAttributedString.Key.font: AppFont.regular.withSize(15),
                NSAttributedString.Key.foregroundColor: colorProvider.titleColor]
    }
    
    // MARK: - Actions
    private lazy var backAction: () -> Void = { [unowned self] in
        self.view.endEditing(true)
        self.router.pop()
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        self.keyboardObserver.stop()
        self.tableAdapter.endEditing(true)
        let txInfo = UtxoTxInfo(address: self.store.address,
                                ammount: self.store.ammount,
                                wallet: self.store.wallet,
                                feePerByte: 100)
        let vc = ConfirmLitecoinTxDetailViewController(self.store.wallet, tx: txInfo)
        vc.modalPresentationStyle = .custom
        self.present(vc, animated: true)
        self.keyboardObserver.start()
        self.store.keyboardHeight = 0
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var inputFeeAction: () -> Void = { [unowned self] in
        self.store.isFeeEnteringDirectly = true
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var readQrAction: () -> Void = { [unowned self] in
        self.keyboardObserver.stop()
        self.tableAdapter.endEditing(true)
        self.router.show(.qrReader(self))
    }
    
    private lazy var addressEditingChanged: (String) -> Void = { [unowned self] address in
        self.store.address = address
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var feeChanged: (Float) -> Void = { [unowned self] fee in
        self.store.selectedFeeSlider = Float(Int(fee))
        self.tableAdapter.hardReload(self.state)
    }
    
    private lazy var feeChangedDirectly: (String) -> Void = { [unowned self] fee in
        self.store.selectedFeeSlider = Float(Int(fee) ?? 5)
        self.tableAdapter.simpleReload(self.state)
    }
    
    // MARK: - QRCodeReaderViewControllerDelegate (Move to wrapper class)
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        keyboardObserver.start()
        dismiss(animated: true)
        if !result.value.contains(charactersIn: EssCharacters.special.set) {
            self.store.address = result.value
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        keyboardObserver.start()
        dismiss(animated: true)
    }
}
