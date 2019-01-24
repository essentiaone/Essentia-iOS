//
//  SendEthTransactionDetailViewController.swift
//  Essentia
//
//  Created by Pavlo Boiko on 11/2/18.
//  Copyright © 2018 Essentia-One. All rights reserved.
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
    var data: String = ""
    var selectedFeeSlider: Float = 3
    var isFeeEnteringDirectly: Bool = false
    var enteredFee: Double = 0.0025
    var gasEstimate: Double = 0
    var lowGasSpeed: Double = 4.0
    var fastGasSpeed: Double = 25.0
    var keyboardHeight: CGFloat = 0
    var qrImage: UIImage {
        return (inject() as AppImageProviderInterface).qrCode
    }
    
    var isValidTransaction: Bool {
        return wallet.asset.isValidAddress(address) && gasEstimate != 0
    }
    
    init(wallet: ViewWalletInterface, transactionAmmount: SelectedTransacrionAmmount) {
        self.wallet = wallet
        self.ammount = transactionAmmount
    }
    
    var isToken: Bool {
        return wallet.asset is Token
    }
    
}

class SendEthTransactionDetailViewController: BaseTableAdapterController, QRCodeReaderViewControllerDelegate {
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
        loadInputs()
        loadRanges()
        keyboardObserver.animateKeyboard = { [unowned self] newValue in
            self.store.keyboardHeight = newValue
            self.tableAdapter.simpleReload(self.state)
        }
        keyboardObserver.start()
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
                                 detail: ammountFormatter.formattedAmmountWithCurrency(ammount: store.ammount.inCrypto)),
            .separator(inset: .zero),
            .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.To"),
                                                  text: store.address,
                                                  placeholder: LS("Wallet.Send.Required"),
                                                  rightButtonImage: store.qrImage,
                                                  rightButtonAction: readQrAction,
                                                  textFieldChanged: addressEditingChanged),
            .separator(inset: .zero)]
            + dataComponent
            + feeComponents +
            [.calculatbleSpace(background: colorProvider.settingsCellsBackround),
             .empty(height: 8, background: colorProvider.settingsCellsBackround),
             .centeredButton(title: LS("Wallet.Send.GenerateTransaction"),
                             isEnable: store.isValidTransaction,
                             action: continueAction,
                             background: colorProvider.settingsCellsBackround),
             .empty(height: store.keyboardHeight, background: colorProvider.settingsCellsBackround)
        ]
    }
    
    var dataComponent: [TableComponent] {
        if !self.store.isToken {
            return [.titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.Data"),
                                                          text: store.data,
                                                          placeholder: LS("Wallet.Send.Optional"),
                                                          rightButtonImage: nil,
                                                          rightButtonAction: nil,
                                                          textFieldChanged: dataEditingChanged)]
        }
        return []
    }
    
    var feeComponents: [TableComponent] {
        let ammountFormatter = BalanceFormatter(asset: self.store.wallet.asset)
        if store.isFeeEnteringDirectly {
            return [.separator(inset: .zero),
                    .titleCenteredDetailTextFildWithImage(title: LS("Wallet.Send.Fee"),
                                                          text:ammountFormatter.formattedAmmount(amount: store.enteredFee),
                                                          placeholder: self.store.wallet.asset.symbol,
                                                          rightButtonImage: nil,
                                                          rightButtonAction: nil,
                                                          textFieldChanged: feeChangedDirectly)]
        }
        return [.attributedTitleDetail(title: formattedFeeTitle, detail: formattedInputFeeButton, action: inputFeeAction),
                .slider(titles: (LS("Wallet.Send.Slow"), LS("Wallet.Send.Normal"), LS("Wallet.Send.Fast")),
                        values: (store.lowGasSpeed, Double(store.selectedFeeSlider), store.fastGasSpeed), didChange: feeChanged)]
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
    
    var formattedFeeTitle: NSAttributedString {
        let currentFee = Double(self.store.selectedFeeSlider) * store.gasEstimate / pow(10, 9)
        self.store.enteredFee = currentFee
        let feeFormatter = BalanceFormatter(asset: EssModel.Coin.ethereum)
        let formattedFee = feeFormatter.formattedAmmountWithCurrency(amount: currentFee)
        let currency = EssentiaStore.shared.currentUser.profile.currency
        let currentRank = EssentiaStore.shared.ranks.getRank(for: Coin.ethereum, on: currency) ?? 0
        let feeInCurrency = currentFee * currentRank
        let formattedFeeInCurrency = BalanceFormatter(currency: currency).formattedAmmountWithCurrency(amount: feeInCurrency)
        let string = LS("Wallet.Send.Fee") + " \(formattedFee) (\(formattedFeeInCurrency))"
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
    private lazy var backAction: () -> Void = { [unowned self] in
        self.view.endEditing(true)
        self.router.pop()
    }
    
    private lazy var continueAction: () -> Void = { [unowned self] in
        self.keyboardObserver.stop()
        self.tableAdapter.endEditing(true)
        let txInfo = EtherTxInfo(address: self.store.address,
                                 ammount: self.store.ammount,
                                 data: self.store.data,
                                 fee: self.store.enteredFee,
                                 gasPrice: Int(self.store.selectedFeeSlider * pow(10, 9)),
                                 gasLimit: Int(self.store.gasEstimate))
        let vc = ConfirmEthereumTxDetailViewController(self.store.wallet, tx: txInfo)
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
        self.store.gasEstimate = 0
        self.loadInputs()
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var dataEditingChanged: (String) -> Void = { [unowned self] data in
        self.store.data = data
        self.loadInputs()
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var feeChanged: (Float) -> Void = { [unowned self] fee in
        self.store.selectedFeeSlider = fee
        self.tableAdapter.simpleReload(self.state)
    }
    
    private lazy var feeChangedDirectly: (String) -> Void = { [unowned self] fee in
        self.store.enteredFee = Double(fee) ?? 0
        self.store.selectedFeeSlider = Float(self.store.enteredFee * pow(10, 9) / self.store.gasEstimate)
        self.tableAdapter.simpleReload(self.state)
    }
    
    // MARK: - QRCodeReaderViewControllerDelegate (Move to wrapper class)
    
    func reader(_ reader: QRCodeReaderViewController, didScanResult result: QRCodeReaderResult) {
        keyboardObserver.start()
        dismiss(animated: true)
        if !result.value.contains(charactersIn: EssCharacters.special.set) {
            self.store.address = result.value
            self.loadInputs()
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    func readerDidCancel(_ reader: QRCodeReaderViewController) {
        keyboardObserver.start()
        dismiss(animated: true)
    }
    
    // MARK: - Network
    
    func loadInputs() {
        let data = self.store.data.isEmpty ? "0x" : self.store.data
        guard let rawParametrs = try? interactor.txRawParametrs(for: store.wallet.asset, toAddress: store.address, ammountInCrypto: store.ammount.inCrypto, data: Data(hex: data)),
            !self.store.address.isEmpty else {
            return
        }
        let seed = EssentiaStore.shared.currentCredentials.seed
        let address = store.wallet.address(withSeed: seed)
        interactor.getEthGasEstimate(fromAddress: address, toAddress: rawParametrs.address, data: rawParametrs.data.toHexString().addHexPrefix()) { [unowned self] (price) in
            (inject() as LoaderInterface).hide()
            self.store.gasEstimate = price
            self.tableAdapter.simpleReload(self.state)
        }
    }
    
    func loadRanges() {
        interactor.getGasSpeed { [unowned self] (low, avarage, fast) in
            self.store.lowGasSpeed = low
            self.store.selectedFeeSlider = Float(avarage)
            self.store.fastGasSpeed = fast
            self.tableAdapter.simpleReload(self.state)
        }
    }
}
